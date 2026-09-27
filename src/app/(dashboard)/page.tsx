import { Card, Badge } from "@/components/ui";

export default function DashboardPage() {
  return (
    <div className="space-y-6">
      {/* Header Banner */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold tracking-tight text-slate-100">
            Clinical Overview
          </h1>
          <p className="text-sm text-slate-400 mt-1">
            Welcome to Clinical OS — Patient EMR and consultation workspace.
          </p>
        </div>
        <Badge variant="info">Phase 1 Active Baseline</Badge>
      </div>

      {/* Metrics Grid */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
        <Card className="flex flex-col justify-between">
          <p className="text-xs font-semibold text-slate-400 uppercase tracking-wider">
            Total Patients
          </p>
          <div className="flex items-baseline justify-between mt-3">
            <span className="text-3xl font-bold text-slate-100">0</span>
            <span className="text-xs text-slate-500">Registered</span>
          </div>
        </Card>

        <Card className="flex flex-col justify-between">
          <p className="text-xs font-semibold text-slate-400 uppercase tracking-wider">
            Today&apos;s Visits
          </p>
          <div className="flex items-baseline justify-between mt-3">
            <span className="text-3xl font-bold text-teal-400">0</span>
            <span className="text-xs text-slate-500">Scheduled</span>
          </div>
        </Card>

        <Card className="flex flex-col justify-between">
          <p className="text-xs font-semibold text-slate-400 uppercase tracking-wider">
            Active Prescriptions
          </p>
          <div className="flex items-baseline justify-between mt-3">
            <span className="text-3xl font-bold text-slate-100">0</span>
            <span className="text-xs text-slate-500">Issued</span>
          </div>
        </Card>

        <Card className="flex flex-col justify-between">
          <p className="text-xs font-semibold text-slate-400 uppercase tracking-wider">
            Pending Follow-ups
          </p>
          <div className="flex items-baseline justify-between mt-3">
            <span className="text-3xl font-bold text-amber-400">0</span>
            <span className="text-xs text-slate-500">This Week</span>
          </div>
        </Card>
      </div>

      {/* Quick Actions & Placeholder */}
      <Card className="p-8 text-center border-dashed border-slate-800">
        <div className="max-w-md mx-auto space-y-3">
          <div className="h-12 w-12 rounded-2xl bg-teal-500/10 border border-teal-500/30 flex items-center justify-center text-teal-400 font-bold text-2xl mx-auto">
            +
          </div>
          <h2 className="text-lg font-semibold text-slate-200">
            Clinical OS Application Shell Initialized
          </h2>
          <p className="text-sm text-slate-400">
            Phase 1 foundation complete: Next.js 16 SSR, Supabase Auth session middleware, route protection, and Clinical OS sidebar shell are active.
          </p>
        </div>
      </Card>
    </div>
  );
}
