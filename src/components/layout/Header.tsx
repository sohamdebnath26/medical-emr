"use client";

import { logout } from "@/lib/actions/auth";

interface HeaderProps {
  userName?: string;
  userRole?: string;
  onOpenWalkIn?: () => void;
}

export function Header({
  userName = "Doctor Workspace",
  userRole = "Doctor",
  onOpenWalkIn,
}: HeaderProps) {
  return (
    <header className="h-16 bg-slate-900/80 backdrop-blur-md border-b border-slate-800/80 px-6 flex items-center justify-between sticky top-0 z-30">
      {/* Quick Search / Clinical Status */}
      <div className="flex items-center gap-4">
        <div className="flex items-center gap-2">
          <span className="text-xs font-semibold uppercase tracking-wider text-slate-400">
            Active Session
          </span>
          <span className="px-2 py-0.5 rounded bg-teal-500/10 border border-teal-500/30 text-teal-400 text-xs font-medium">
            Clinical OS
          </span>
        </div>
      </div>

      {/* Header Actions & Profile */}
      <div className="flex items-center gap-4">
        {onOpenWalkIn && (
          <button
            onClick={onOpenWalkIn}
            className="flex items-center gap-2 px-3.5 py-1.5 rounded-lg bg-teal-500 hover:bg-teal-400 text-slate-950 text-xs font-semibold transition-all shadow-sm shadow-teal-500/20"
          >
            <svg
              className="w-4 h-4"
              fill="none"
              stroke="currentColor"
              viewBox="0 0 24 24"
            >
              <path
                strokeLinecap="round"
                strokeLinejoin="round"
                strokeWidth="2"
                d="M12 4.5v15m7.5-7.5h-15"
              />
            </svg>
            <span>Walk-in Patient</span>
          </button>
        )}

        <div className="h-4 w-[1px] bg-slate-800" />

        {/* User Badge */}
        <div className="flex items-center gap-3">
          <div className="h-8 w-8 rounded-full bg-slate-800 border border-slate-700 flex items-center justify-center text-teal-400 font-semibold text-xs">
            {userName ? userName.charAt(0).toUpperCase() : "D"}
          </div>
          <div className="text-left hidden sm:block">
            <p className="text-xs font-medium text-slate-200 leading-none">
              {userName}
            </p>
            <p className="text-[10px] text-slate-400 mt-0.5 capitalize">
              {userRole}
            </p>
          </div>
        </div>

        {/* Logout Form */}
        <form action={logout}>
          <button
            type="submit"
            className="p-2 text-slate-400 hover:text-rose-400 hover:bg-slate-800/60 rounded-lg transition-colors"
            title="Sign out"
          >
            <svg
              className="w-4 h-4"
              fill="none"
              stroke="currentColor"
              viewBox="0 0 24 24"
            >
              <path
                strokeLinecap="round"
                strokeLinejoin="round"
                strokeWidth="2"
                d="M15.75 9V5.25A2.25 2.25 0 0013.5 3h-6a2.25 2.25 0 00-2.25 2.25v13.5A2.25 2.25 0 007.5 21h6a2.25 2.25 0 002.25-2.25V15M12 9l-3 3m0 0l3 3m-3-3h12.75"
              />
            </svg>
          </button>
        </form>
      </div>
    </header>
  );
}
