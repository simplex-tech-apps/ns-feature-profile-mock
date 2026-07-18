//
//  ProfileCoordinator.swift
//  NSFeatureProfileMock
//
//  Created by apple on 12/07/26.
//

import SwiftData
import SwiftUI
import NammaAppUI

@MainActor
struct ProfileViewFactory {
    @ViewBuilder
    func buildPage(_ page: ProfileCoordinatorPage) -> some View {
        switch page {
        case .landingPage(let profileViewModel):
            ProfileLandingView(profileViewModel: profileViewModel)
        }
    }
    
    @ViewBuilder
    func buildSheet(_ sheet: ProfileCoordinatorSheet) -> some View {
        EmptyView()
    }
    
    @ViewBuilder
    func buildCover(_ cover: ProfileCoordinatorCover) -> some View {
        EmptyView()
    }
}

enum ProfileCoordinatorPage: Hashable {
    case landingPage(ProfileViewModel)
}

enum ProfileCoordinatorSheet: String, Identifiable {
    var id: String { rawValue }
    case noSheet
}

enum ProfileCoordinatorCover: String, Identifiable {
    var id: String { rawValue }
    case noCover
}

extension EnvironmentValues {
    @Entry var ProfileCoordinator: ProfileCoordinator?
    @Entry var ProfileViewModel: ProfileViewModel?
}

@Observable
class ProfileCoordinator: NSObject {
    var path: NavigationPath = NavigationPath()
    var sheet: ProfileCoordinatorSheet?
    var cover: ProfileCoordinatorCover?
    private(set) var currenScreen: [ProfileCoordinatorPage] = []
    
    func push(page: ProfileCoordinatorPage) {
        currenScreen.append(page)
        path.append(page)
    }
    
    func pop(_ last: Int = 1) {
        currenScreen.removeLast()
        path.removeLast(last)
    }
    
    func popToRoot() {
        currenScreen.removeAll()
        path.removeLast(path.count)
    }
    
    func present(sheet: ProfileCoordinatorSheet) {
        self.sheet = sheet
    }
    
    func present(cover: ProfileCoordinatorCover) {
        self.cover = cover
    }
    
    func popSheet() {
        withAnimation(.spring()) {
            self.sheet = nil
        }
    }
    
    func popCover() {
        self.cover = nil
    }
}   

public struct ProfileCoordinatorView: View {
    @State
    private var profileCoordinator = ProfileCoordinator()
    @State
    private var profileViewModel: ProfileViewModel = ProfileViewModel()
    @State
    private var appTheme = AppThemeManager.shared
    
    let profileViewFactory: ProfileViewFactory = ProfileViewFactory()
    
    public init() {}
    
    public var body: some View {
        profileViewFactory.buildPage(.landingPage(profileViewModel))
            .navigationDestination(for: ProfileCoordinatorPage.self) {
                profileViewFactory.buildPage($0)
            }
            .sheet(item: $profileCoordinator.sheet) { profileViewFactory.buildSheet($0).presentationBackground(appTheme.current.secondary).presentationDetents([.medium]).presentationCornerRadius(24)
            }
            .fullScreenCover(item: $profileCoordinator.cover) {
                profileViewFactory.buildCover($0)
            }
    }
}
