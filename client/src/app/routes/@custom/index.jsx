import WaitingListNew from "../../pages/static/@custom/WaitingListNew.jsx";
import AdminUsersList from "../../pages/static/@custom/admin/AdminUsersList.jsx";
import AdminUserDetail from "../../pages/static/@custom/admin/AdminUserDetail.jsx";

const customRoutes = [
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