export default function Onboarding() {
  return (
    <form>
      <input placeholder="Your name" />
      <input placeholder="Company" />
      <input placeholder="Team size" />
      <input placeholder="Role" />
      <input placeholder="Invite teammates (comma separated)" />
      <label><input type="checkbox" defaultChecked /> Send me product news</label>
      <button className="btn" disabled>Continue</button>
    </form>
  );
}
