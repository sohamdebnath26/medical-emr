import { Card, Badge } from "@/components/ui";

export default function PrescriptionsPage() {
  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold tracking-tight text-slate-100">
            Prescriptions
          </h1>
          <p className="text-sm text-slate-400 mt-1">
            Overview of patient prescriptions issued during consultations.
          </p>
        </div>
        <Badge variant="info">Pharmacy Log</Badge>
      </div>

      <Card className="p-8 text-center border-dashed border-slate-800">
        <p className="text-slate-400 text-sm">
          Prescription history and generation tool shell active.
        </p>
      </Card>
    </div>
  );
}
