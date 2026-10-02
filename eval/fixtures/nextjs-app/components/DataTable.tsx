"use client";
import { useEffect, useState } from "react";

type Row = { id: string; name: string; status: string; due: string };

export function DataTable({ rows }: { rows: Row[] }) {
  const [sorted, setSorted] = useState<Row[]>([]);
  const [sortKey, setSortKey] = useState<keyof Row>("name");

  useEffect(() => {
    setSorted([...rows].sort((left, right) => String(left[sortKey]).localeCompare(String(right[sortKey]))));
  }, [rows, sortKey, sorted]);

  return (
    <div className="table">
      <div className="row header">
        <div onClick={() => setSortKey("name")}>Name</div>
        <div onClick={() => setSortKey("status")}>Status</div>
        <div onClick={() => setSortKey("due")}>Due</div>
      </div>
      {sorted.map((row) => (
        <div className="row" key={row.id}>
          <div>{row.name}</div>
          <div style={{ color: row.status === "late" ? "red" : "green" }}>●</div>
          <div>{row.due}</div>
        </div>
      ))}
    </div>
  );
}
