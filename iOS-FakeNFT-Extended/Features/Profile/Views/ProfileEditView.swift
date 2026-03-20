import SwiftUI
import Observation

struct ProfileEditView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var viewModel: ProfileEditViewModel
    private let onSave: (Profile) -> Void

    @State private var userInputPhotoUrl: String = ""
    @State private var isImageLoadingFailedAlertPresented = false
    @FocusState private var isInputFocused: Bool
    @State private var isChangeAvatarDialogPresented = false
    @State private var isChangeAvatarLinkAlertPresented = false
    @State private var isWrongUrlAlertPresented = false

    init(
        profile: Profile,
        profileService: ProfileService,
        onSave: @escaping (Profile) -> Void = { _ in }
    ) {
        _viewModel = State(initialValue: ProfileEditViewModel(profile: profile, profileService: profileService))
        self.onSave = onSave
    }
    
    var body: some View {
        @Bindable var viewModel = viewModel
        VStack(spacing: 24) {
            photoStack
            makeBlock(header: "Имя", text: $viewModel.nameText)
            makeBlock(header: "Описание", text: $viewModel.descriptionText, lineLimit: 5)
            makeBlock(header: "Сайт", text: $viewModel.siteText)
            Spacer()
            if viewModel.hasChanges {
                saveButton
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .contentShape(Rectangle())
        .padding(.top, .zero)
        .navigationBarBackButtonHidden(true)
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundStyle(.ypBlack)
                }
            }
        }
        .confirmationDialog(
            "Фото профиля",
            isPresented: $isChangeAvatarDialogPresented
        ) {
            Button("Изменить фото") {
                changeActionTapped()
            }
            Button("Удалить фото", role: .destructive) {
                deleteActionTapped()
            }
            Button("Отмена", role: .cancel) {

            }
        }
        .alert("Ссылка на фото", isPresented: $isChangeAvatarLinkAlertPresented)
        {
            TextField("https://", text: $userInputPhotoUrl)
                .keyboardType(.URL)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
            Button("Отмена") {}
            Button("Сохранить") {
                savePhotoLink()
            }
        }
        .alert("В данном поле должна быть ссылка на изображение", isPresented: $isWrongUrlAlertPresented) {
            Button("Ок") {
                isWrongUrlAlertPresented = false
                isChangeAvatarLinkAlertPresented = true
            }
        }
        .alert("Не удалось сохранить профиль", isPresented: .constant(viewModel.isSaveErrorPresented)) {
            Button("Ок", role: .cancel) {
                viewModel.dismissSaveError()
            }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
        .alert("Не удалось загрузить изображение", isPresented: $isImageLoadingFailedAlertPresented) {
            Button("Ок") {
                viewModel.restorePreviousPhoto()
            }
        } message: {
            Text("Проверьте ссылку на изображение")
        }
        .onTapGesture {
            isInputFocused = false
        }
    }

    private var saveButton: some View {
        Button {
            saveTapped()
        } label: {
            if viewModel.isLoading {
                ProgressView()
                    .tint(.ypWhite)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
            } else {
                Text("Сохранить")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(.ypWhite)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
            }
        }
        .background(Color.ypBlack)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .disabled(viewModel.isLoading)
        .padding(.horizontal, 16)
        .padding(.bottom, 16)
    }

    private func saveTapped() {
        Task {
            do {
                let savedProfile = try await viewModel.saveProfile()
                onSave(savedProfile)
                dismiss()
            } catch {
            }
        }
    }

    private func changeActionTapped() {
        userInputPhotoUrl = viewModel.photoUrl?.absoluteString ?? ""
        isChangeAvatarLinkAlertPresented = true
    }

    private func deleteActionTapped() {
        viewModel.deletePhoto()
    }

    private func editPhotoTapped() {
        isChangeAvatarDialogPresented = true
    }

    private func savePhotoLink() {
        if !viewModel.applyPhotoLink(userInputPhotoUrl) {
            isWrongUrlAlertPresented = true
        }
    }

    private var photoStack: some View {
        Button {
            editPhotoTapped()
        } label: {
            ZStack(alignment: .bottomTrailing) {
                photo
                Image(systemName: "camera.fill")
                    .resizable()
                    .foregroundStyle(.ypBlack)
                    .scaledToFit()
                    .frame(width: 12, height: 10)
                    .background(
                        Circle()
                            .frame(width: 22, height: 22)
                            .foregroundStyle(.ypLightGrey)
                    )
                    .offset(x: -2, y: -2)
            }
        }
        .buttonStyle(.plain)
    }

    private var photo: some View {
        Group {
            if let photoUrl = viewModel.photoUrl {
                AsyncImage(url: photoUrl) { phase in
                    switch phase {
                    case .empty:
                        ZStack {
                            Circle()
                                .foregroundStyle(.ypLightGrey)
                                .frame(width: 70, height: 70)
                            ProgressView()
                                .tint(.ypBlack)
                        }
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 70, height: 70)
                            .clipShape(Circle())
                    case .failure:
                        placeholderPhoto
                            .onAppear {
                                if viewModel.previousPhotoUrl != nil {
                                    isImageLoadingFailedAlertPresented = true
                                }
                            }
                    @unknown default:
                        placeholderPhoto
                    }
                }
            } else {
                placeholderPhoto
            }
        }
    }

    private var placeholderPhoto: some View {
        Image(systemName: "person.crop.circle.fill")
            .resizable()
            .scaledToFill()
            .frame(width: 70, height: 70)
            .foregroundStyle(.gray)
    }

    private func makeBlock(
        header: String,
        text: Binding<String>,
        lineLimit: Int = 1
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(header)
                .font(.system(size: 22, weight: .bold))
            TextField("", text: text, axis: .vertical)
                .lineLimit(lineLimit, reservesSpace: true)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color.ypLightGrey)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .focused($isInputFocused)
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    ProfileEditView(
        profile: Profile(
            id: "1",
            name: "Максим Пупс",
            avatar: "https://i.pinimg.com/736x/e2/b3/ff/e2b3ff329c3a6ce26afcd1c53d9de30a.jpg",
            description: "Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT, и еще больше — на моём сайте. Открыт к коллаборациям.",
            website: "https://maxipups.com",
            nfts: [],
            likes: []
        ),
        profileService: ProfileServiceImpl(networkClient: DefaultNetworkClient())
    )
}
