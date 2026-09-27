import { Card, Badge } from "@/components/ui";

export default function AIAssistantPage() {
  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold tracking-tight text-slate-100">
            AI Assistant
          </h1>
          <p className="text-sm text-slate-400 mt-1">
            Clinical AI helper and consultation summary companion.
          </p>
        </div>
        <Badge variant="warning">AI Provider Shell</Badge>
      </div>

      <Card className="p-8 text-center border-dashed border-slate-800">
        <p className="text-slate-400 text-sm">
          AI assistant interface shell initialized. Provider integration ready for connection.
        </p>
      </Card>
    </div>
  );
}
