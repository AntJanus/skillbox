const tiers = [
  { name: "Starter", price: 0, features: ["3 projects", "Basic reports"] },
  { name: "Team", price: 12, features: ["Unlimited projects", "Advanced reports", "Integrations", "Guest access", "Priority email", "SSO", "Audit log", "Custom fields"] },
  { name: "Business", price: 29, features: ["Everything", "Dedicated manager"] },
];

export default function Pricing() {
  return (
    <div>
      <h1>Pricing</h1>
      {tiers.map((tier) => (
        <div key={tier.name} className="card">
          <h2>{tier.name}</h2>
          <p>${tier.price}</p>
          <ul>{tier.features.map((feature) => <li key={feature}>{feature}</li>)}</ul>
          <button className="btn">Choose</button>
        </div>
      ))}
    </div>
  );
}
