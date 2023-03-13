import Image from "next/image";

export default function Footer() {
  return (
    <div className="space-between flex items-end justify-end text-4xl text-secondary">
      <Image
        src="/logos/CeSIUM-icon.svg"
        alt="Logo"
        width={60}
        height={20}
        className="mr-auto h-10 w-10 justify-start text-white hover:text-secondary"
        href="https://cesium.di.uminho.pt"
      />
      <div className="flex flex-row justify-end">
        <Image
          src="/logos/facebook.svg"
          alt="Logo"
          width={60}
          height={20}
          className="mr-4 h-10 w-10 text-white hover:text-secondary"
          href="https://www.facebook.com/cesiuminho"
        />
        <Image
          src="/logos/instagram.svg"
          alt="Logo"
          width={65}
          height={20}
          className="mr-4 h-10 w-10 text-white hover:text-secondary"
          href="https://www.instagram.com/cesiuminho/"
        />
        <Image
          src="/logos/twitter.svg"
          alt="Logo"
          width={80}
          height={60}
          className="mr-4 h-10 w-10 text-white hover:text-secondary"
          href="https://twitter.com/cesiuminho"
        />
      </div>
    </div>
  );
}
