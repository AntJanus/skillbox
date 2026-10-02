"use client";
import { useState } from "react";

export function UserMenu() {
  const [open, setOpen] = useState(false);
  return (
    <div>
      <div onClick={() => setOpen(!open)} className="avatar">ME ▾</div>
      {open && (
        <div className="menu">
          <div onClick={() => (location.href = "/settings")}>Settings</div>
          <div onClick={() => (location.href = "/billing")}>Billing</div>
          <div onClick={() => (location.href = "/logout")}>Log out</div>
        </div>
      )}
    </div>
  );
}
