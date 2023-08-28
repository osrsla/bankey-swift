import UIKit

// 1. 정보를 보내는 곳에서 프로토콜 델리게이트 만들기
protocol OnboardingContainerViewControllerDelegate: AnyObject {
    func didFinishOnboarding()
}

class OnboardingContainerViewController: UIViewController {
    let pageViewController: UIPageViewController
    var pages = [UIViewController]()

    // 2. 정보를 보내는 곳에 weak var 델리게이트 변수 생성(weak 약한 결합 시 옵셔널(?) 필수)
    weak var delegate: OnboardingContainerViewControllerDelegate?

    var currentVC: UIViewController { didSet {}}

    var closeButton = UIButton(type: .system)

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)

        let page1 = OnboardingViewController(heroImageName: "delorean", titleText: "Bankey is faster, easier to use, and has a brand new look and feel that will make you feel like you are back in the 80s.")
        let page2 = OnboardingViewController(heroImageName: "world", titleText: "Move your money around the world quickly and securely.")
        let page3 = OnboardingViewController(heroImageName: "thumbs", titleText: "Learn more at www.bankey.com.")

        pages.append(page1)
        pages.append(page2)
        pages.append(page3)

        currentVC = pages.first!

        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        setupStyle()
        setupLayout()
    }

    private func setup() {
        view.backgroundColor = .systemPurple

        // 차일드뷰 추가 3 steps
        // 1. 현재 뷰컨트롤러에 자식으로 추가. pageVC가 뷰 컨트롤러의 계층 구조에 포함됨
        addChild(pageViewController)
        // 2. pageViewController의 뷰를 현재 뷰 컨트롤러의 서브뷰로 추가. pageVC의 뷰가 현재 뷰 컨트롤러의 인터페이스에 나타남
        view.addSubview(pageViewController.view)
        // 3. pageVC에게 뷰 계층에 추가되었음 알림
        pageViewController.didMove(toParent: self)

        pageViewController.dataSource = self
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: pageViewController.view.topAnchor),
            view.leadingAnchor.constraint(equalTo: pageViewController.view.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: pageViewController.view.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: pageViewController.view.bottomAnchor),
        ])

        pageViewController.setViewControllers([pages.first!], direction: .forward, animated: false, completion: nil)
        currentVC = pages.first!
    }

    private func setupStyle() {
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.setTitle("Close", for: [])
        closeButton.addTarget(self, action: #selector(closeTapped), for: .primaryActionTriggered)

        view.addSubview(closeButton)
    }

    private func setupLayout() {
        // Close Button
        NSLayoutConstraint.activate([
            closeButton.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            closeButton.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 2),

        ])
    }
}

// MARK: - UIPageViewControllerDataSource

extension OnboardingContainerViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return getPreviousViewController(from: viewController)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return getNextViewController(from: viewController)
    }

    private func getPreviousViewController(from viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController), index - 1 >= 0 else { return nil }
        currentVC = pages[index - 1]
        return pages[index - 1]
    }

    private func getNextViewController(from viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController), index + 1 < pages.count else { return nil }
        currentVC = pages[index + 1]
        return pages[index + 1]
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return pages.firstIndex(of: currentVC) ?? 0
    }
}

// MARK: - Actions

extension OnboardingContainerViewController {
    @objc func closeTapped(_ sender: UIButton) {
        // 3. 델리게이트 변수로 정보 쏘기
        delegate?.didFinishOnboarding()
    }
}
