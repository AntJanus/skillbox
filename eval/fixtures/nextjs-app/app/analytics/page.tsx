import { getTasks } from "@/lib/data";

export default async function Analytics() {
  const tasks = await getTasks();
  const completed = tasks.filter((task) => task.status === "done").length;
  return (
    <div>
      <h1>Analytics</h1>
      <p>{completed} of {tasks.length} tasks completed</p>
    </div>
  );
}
