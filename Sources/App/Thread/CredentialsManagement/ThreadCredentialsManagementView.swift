import Shared
import SwiftUI

struct ThreadCredentialsManagementView: View {
    @StateObject private var viewModel: ThreadCredentialsManagementViewModel

    init(viewModel: ThreadCredentialsManagementViewModel) {
        self._viewModel = .init(wrappedValue: viewModel)
    }

    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(.circular)
            } else {
                listView
            }
        }
        .navigationTitle(L10n.Thread.Management.title)
        .onAppear {
            Task.detached {
                await viewModel.loadCredentials()
            }
        }
    }

    private var listView: some View {
        List(viewModel.configs, id: \.id) { config in
            Section(config.name) {
                ForEach(config.credentials, id: \.autogeneratedId) { credential in
                    CollapsibleView(collapsedContent: {
                        Text(credential.networkName)
                            .padding(.vertical, 8)
                    }, expandedContent: {
                        ThreadCredentialDetailsView(source: config.source, credential: credential)
                            .padding(.top)
                    })
                }
            }
        }
        .environmentObject(viewModel)
    }
}

#Preview {
    ThreadCredentialsManagementView.build()
}
