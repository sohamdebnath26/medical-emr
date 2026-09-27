import { getUser } from "@/lib/actions/auth";
import { AppShell } from "@/components/layout/AppShell";

export default async function DashboardLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  const user = await getUser();

  return (
    <AppShell
      userName={user?.email || "Doctor Workspace"}
      userRole="Doctor"
    >
      {children}
    </AppShell>
  );
}
