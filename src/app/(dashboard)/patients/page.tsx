import { Card, Badge } from "@/components/ui";

export default function PatientsPage() {
  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold tracking-tight text-slate-100">
            Patient Directory
          </h1>
          <p className="text-sm text-slate-400 mt-1">
            Search, register, and view clinical histories for clinic patients.
          </p>
        </div>
        <Badge variant="info">Patient EMR</Badge>
      </div>

      <Card className="p-8 text-center border-dashed border-slate-800">
        <p className="text-slate-400 text-sm">
          Patient search, walk-in registration modal, and profile timeline will be enabled in subsequent workflow phase.
        </p>
      </Card>
    </div>
  );
}
