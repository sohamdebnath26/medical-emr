import { Card, Badge } from "@/components/ui";

export default function SettingsPage() {
  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold tracking-tight text-slate-100">
            Settings
          </h1>
          <p className="text-sm text-slate-400 mt-1">
            Clinic preferences, doctor profile, and system configuration.
          </p>
        </div>
        <Badge variant="default">System Config</Badge>
      </div>

      <Card className="p-8 text-center border-dashed border-slate-800">
        <p className="text-slate-400 text-sm">
          Settings shell initialized.
        </p>
      </Card>
    </div>
  );
}
