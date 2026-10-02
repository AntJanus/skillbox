import { describe, expect, it } from "vitest";
import { getProjects } from "../lib/data";

describe("getProjects", () => {
  it("returns projects with titles", async () => {
    const projects = await getProjects();
    expect(projects[0].title).toBe("Website relaunch");
  });
});
