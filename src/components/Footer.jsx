import Image from "next/image";

export default function Footer() {
  return (
    <div className="space-between flex items-end justify-end text-4xl text-secondary">
      <Image
        src="/logos/CeSIUM-icon.svg"
        alt="Logo"
        width={60}
        height={20}
        className="mr-auto justify-start"
        href="https://cesium.di.uminho.pt"
      />
      <div className="flex flex-row justify-end">
        <Image
          src="/logos/facebook.svg"
          alt="Logo"
          width={65}
          height={20}
          className="mr-4"
          href="https://www.facebook.com/cesiuminho"
        />
        <Image
          src="/logos/instagram.svg"
          alt="Logo"
          width={65}
          height={20}
          className="mr-4"
          href="https://www.instagram.com/cesiuminho/"
        />
        <Image
          src="/logos/twitter.svg"
          alt="Logo"
          width={80}
          height={60}
          href="https://twitter.com/cesiuminho"
        />
      </div>
    </div>
  );
}
