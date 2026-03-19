import SwiftUI

struct ProfileEditView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var userInputPhotoUrl: String = ""
    @State private var photoUrl: URL? = URL(
        string:
            "https://i.pinimg.com/736x/e2/b3/ff/e2b3ff329c3a6ce26afcd1c53d9de30a.jpg"
    )!
    @State private var previousPhotoUrl: URL?
    @State private var isImageLoadingFailedAlertPresented = false
    @FocusState private var isInputFocused: Bool
    @State private var nameText: String = "Максим Пупс"
    @State private var descriptionText: String =
        "Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT, и еще больше — на моём сайте. Открыт к коллаборациям."
    @State private var siteText: String = "https://maxipups.com"
    @State private var isChangeAvatarDialogPresented = false
    @State private var isChangeAvatarLinkAlertPresented = false
    @State private var isWrongUrlAlertPresented = false
    
    var body: some View {
        VStack(spacing: 24) {
            photoStack
            makeBlock(header: "Имя", text: $nameText)
            makeBlock(header: "Описание", text: $descriptionText, lineLimit: 5)
            makeBlock(header: "Сайт", text: $siteText)
            Spacer()
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
        .alert("Не удалось загрузить изображение", isPresented: $isImageLoadingFailedAlertPresented) {
            Button("Ок") {
                photoUrl = previousPhotoUrl
                previousPhotoUrl = nil
            }
        } message: {
            Text("Проверьте ссылку на изображение")
        }
        .onTapGesture {
            isInputFocused = false
        }
    }

    private func changeActionTapped() {
        userInputPhotoUrl = photoUrl?.absoluteString ?? ""
        isChangeAvatarLinkAlertPresented = true
    }

    private func deleteActionTapped() {
        photoUrl = nil
    }

    private func editPhotoTapped() {
        isChangeAvatarDialogPresented = true
    }

    private func savePhotoLink() {
        let trimmedInput = userInputPhotoUrl.trimmingCharacters(in: .whitespacesAndNewlines)
        let normalizedInput = normalizePhotoURLString(trimmedInput)

        guard let url = URL(string: normalizedInput),
              let scheme = url.scheme?.lowercased(),
              ["http", "https"].contains(scheme),
              let host = url.host,
              !host.isEmpty else {
            isWrongUrlAlertPresented = true
            return
        }

        previousPhotoUrl = photoUrl
        userInputPhotoUrl = normalizedInput
        photoUrl = url
    }

    private func normalizePhotoURLString(_ input: String) -> String {
        guard !input.isEmpty else { return input }

        if input.lowercased().hasPrefix("http://") ||
            input.lowercased().hasPrefix("https://") {
            return input
        }

        return "https://\(input)"
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
            if let photoUrl {
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
                                if previousPhotoUrl != nil {
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
    ProfileEditView()
}
