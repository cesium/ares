import Image from "next/image";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import {
  faInstagram,
  faFacebook,
  faTwitter,
} from "@fortawesome/free-brands-svg-icons";

import logo from "../../public/logos/CeSIUM-icon.svg";

export default function Footer() {
  return (
    <div className="space-between flex items-end justify-end pt-[120px] text-4xl text-secondary">
      <a
        href="https://cesium.di.uminho.pt/"
        target="_blank"
        rel="noreferrer"
        className="mr-auto"
      >
        <Image
          src={logo}
          alt="CeSIUM"
          className="h-20 w-20 justify-start text-white hover:text-secondary"
        />
      </a>
      <div className="mb-2 flex items-center justify-end">
        <a
          href="https://www.instagram.com/cesiuminho/"
          target="_blank"
          rel="noreferrer"
        >
          <FontAwesomeIcon
            icon={faInstagram}
            className="mr-4 h-10 w-10 text-white hover:text-secondary"
          />
        </a>
        <a
          href="https://www.facebook.com/cesiuminho"
          target="_blank"
          rel="noreferrer"
        >
          <FontAwesomeIcon
            icon={faFacebook}
            className="mr-4 h-10 w-10 text-white hover:text-secondary"
          />
        </a>
        <a
          href="https://twitter.com/cesiuminho"
          target="_blank"
          rel="noreferrer"
        >
          <FontAwesomeIcon
            icon={faTwitter}
            className="mr-4 h-10 w-10 text-white hover:text-secondary"
          />
        </a>
      </div>
    </div>
  );
}
