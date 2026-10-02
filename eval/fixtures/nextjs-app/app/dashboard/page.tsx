import { ProjectCard } from "@/components/ProjectCard";
import { UserMenu } from "@/components/UserMenu";
import { DataTable } from "@/components/DataTable";
import { getProjects, getTasks } from "@/lib/data";

export default async function Dashboard() {
  const projects = await getProjects();
  const tasks = await getTasks();
  return (
    <div>
      <div style={{ display: "flex", justifyContent: "space-between" }}>
        <h1>Dashboard</h1>
        <UserMenu />
      </div>
      <div style={{ display: "flex", gap: 8 }}>
        <button className="btn">New project</button>
        <button className="btn">Import</button>
        <button className="btn">Export</button>
        <button className="btn">Share</button>
        <button className="btn">Archive all</button>
        <button className="btn" style={{ background: "red" }}>Delete all</button>
      </div>
      <div style={{ display: "flex", gap: 12, flexWrap: "wrap" }}>
        {projects.map((project) => (
          <ProjectCard key={project.id} project={project} />
        ))}
      </div>
      <h2>Tasks</h2>
      <DataTable rows={tasks} />
    </div>
  );
}
