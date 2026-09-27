"use client";

import { Sidebar } from "./Sidebar";
import { Header } from "./Header";

interface AppShellProps {
  children: React.ReactNode;
  userName?: string;
  userRole?: string;
  onOpenWalkIn?: () => void;
}

export function AppShell({
  children,
  userName,
  userRole,
  onOpenWalkIn,
}: AppShellProps) {
  return (
    <div className="flex min-h-screen bg-slate-950 text-slate-100">
      {/* Persistent Left Sidebar */}
      <Sidebar onOpenWalkIn={onOpenWalkIn} />

      {/* Main Workspace Area */}
      <div className="flex-1 flex flex-col min-w-0 overflow-hidden">
        <Header
          userName={userName}
          userRole={userRole}
          onOpenWalkIn={onOpenWalkIn}
        />

        <main className="flex-1 overflow-y-auto p-6 bg-slate-950/60">
          <div className="max-w-7xl mx-auto">{children}</div>
        </main>
      </div>
    </div>
  );
}
