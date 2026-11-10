import Link from "next/link";

const messages: Record<string, string> = {
  invalid_state: "The sign-in request expired or could not be verified. Please try again.",
  token_exchange_failed: "The identity provider rejected the sign-in exchange. Check the web client configuration.",
  api_token_rejected: "The API rejected the access token. Check the Keycloak API audience configuration.",
  authentication_failed: "Sign-in could not be completed. Check Keycloak and API logs, then try again.",
  access_denied: "Your account is not authorized for this workspace."
};

export default async function LoginPage({ searchParams }: { searchParams: Promise<{ error?: string; signed_out?: string }> }) {
  const params = await searchParams;
  const message = params.error ? messages[params.error] ?? "Sign-in was not completed." : null;
  return <main className="login-page">
    <section className="login-card">
      <div className="login-brand"><span className="brand-mark">SG</span><div><strong>SPECIAL GROUP</strong><small>OPERATIONS PLATFORM</small></div></div>
      <p className="eyebrow">SECURE WORKSPACE</p>
      <h1>Sign in to SGSCTR</h1>
      <p className="login-copy">Use your organization-provisioned account. Access is authenticated by the self-hosted identity service.</p>
      {params.signed_out && <p className="login-success">You have signed out.</p>}
      {message && <p className="login-error" role="alert">{message}</p>}
      <Link className="login-button" href="/api/auth/login">Continue with secure sign-in <span>↗</span></Link>
      <p className="login-foot">No public registration. Contact the authorized workspace administrator for account provisioning.</p>
    </section>
  </main>;
}
