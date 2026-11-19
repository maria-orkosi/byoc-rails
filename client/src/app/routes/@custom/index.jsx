import WaitingListNew from "../../pages/static/@custom/WaitingListNew.jsx";
import OnboardingFlow from "../../pages/@custom/OnboardingFlow.jsx";

const customRoutes = [
  {
    path: "/waiting_list/new",
    element: <WaitingListNew />,
  },
  {
    path: "/onboarding",
    element: <OnboardingFlow />,
    navLabel: "Get Started",
    navIcon: "Rocket",
  },
];

export default customRoutes;

export const customNavItems = [
  {
    path: "/onboarding",
    label: "Get Started",
    icon: "Rocket",
  },
];