import HealthStatusPage from "../../pages/static/@custom/health-status.jsx";
import OnboardingPage from "../../pages/static/@custom/onboarding.jsx";
import DashboardPage from "../../pages/static/@custom/dashboard.jsx";

export const customRoutes = [
  {
    path: "/health-status",
    element: <HealthStatusPage />,
    label: "System Health",
  },
  {
    path: "/onboarding",
    element: <OnboardingPage />,
    label: "Onboarding",
  },
  {
    path: "/projects",
    element: <DashboardPage />,
    label: "Dashboard",
  },
  {
    path: "/projects/:id",
    element: <DashboardPage />,
    label: "Project",
  },
];