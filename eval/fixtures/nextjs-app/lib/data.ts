export async function getProjects() {
  return [
    { id: "1", title: "Website relaunch", owner: "Dana", coverUrl: "/covers/1.png", progress: 72 },
    { id: "2", title: "Q4 customer onboarding improvements for enterprise accounts in EMEA", owner: "Lee", coverUrl: "/covers/missing.png", progress: 20 },
  ];
}

export async function getTasks() {
  return [
    { id: "t1", name: "Write brief", status: "done", due: "2026-10-01" },
    { id: "t2", name: "Review copy", status: "late", due: "2026-09-28" },
  ];
}
