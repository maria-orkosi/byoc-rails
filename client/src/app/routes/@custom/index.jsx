import WaitingListNew from "../../pages/static/@custom/WaitingListNew.jsx";
import AdminUsersList from "../../pages/static/@custom/admin/AdminUsersList.jsx";
import AdminUserDetail from "../../pages/static/@custom/admin/AdminUserDetail.jsx";
import LandingPage from "../../pages/static/@custom/LandingPage/index.jsx";

const customRoutes = [
  {
    path: "/",
    element: <LandingPage />,
  },
  {
    path: "/waiting_list/new",
    element: <WaitingListNew />,
  },
  {
    path: "/admin/users",
    element: <AdminUsersList />,
  },
  {
    path: "/admin/users/:id",
    element: <AdminUserDetail />,
  },
];

export default customRoutes;