export default function FormsTemplate({ title, description, children }) {
  return (
    <div className="mx-auto max-w-7xl px-4 pb-24 sm:px-6 lg:px-8">
      <div className="mx-auto max-w-3xl">
        <div className="mt-10 mb-10">
          <h2 className="font-semibold tracking-wide text-3xl leading-7 text-white">
            {title}
          </h2>
          <p className="mt-1 max-w-2xl text-xl leading-6 text-white">
            {description}
          </p>
        </div>
        <div>{children}</div>
      </div>
    </div>
  );
}
