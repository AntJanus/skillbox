export default function Checkout() {
  return (
    <form>
      <h1>Checkout</h1>
      <input placeholder="Card number" />
      <input placeholder="MM/YY" />
      <input placeholder="CVC" />
      <label><input type="checkbox" defaultChecked /> Add priority support (+$9/mo)</label>
      <button className="btn">Pay now</button>
    </form>
  );
}
