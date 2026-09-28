import { getUser } from "@/lib/actions/auth";
import { AppShell } from "@/components/layout/AppShell";

export default async function DashboardLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  const user = await getUser();
  const isAnonymous = Boolean(user?.is_anonymous);

  return (
    <AppShell
      userName={user?.email || "Doctor Workspace"}
      userRole="Doctor"
      isAnonymous={isAnonymous}
    >
      {children}
    </AppShell>
  );
}
