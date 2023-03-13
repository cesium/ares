import React from "react";
import DateTimeDisplay from "../hooks/DateTimeDisplay";
import { useCountdown } from "../hooks/useCountdown";

const ExpiredNotice = () => {
  return (
    <div className="expired-notice">
      <span>Expired!!!</span>
      <p>Please select a future date and time.</p>
    </div>
  );
};

const ShowCounter = ({ days, hours, minutes, seconds }) => {
  return (
    <div className="font-alarmclock-uppercase p-4 text-center text-4xl text-white xl:text-7xl">
      <a
        target="_blank"
        rel="noopener noreferrer"
        className="flex flex-row items-center justify-center"
      >
        <DateTimeDisplay value={days} isDanger={days <= 3} />
        <p>:</p>
        <DateTimeDisplay value={hours} isDanger={false} />
        <p>:</p>
        <DateTimeDisplay value={minutes} isDanger={false} />
        <p>:</p>
        <DateTimeDisplay value={seconds} isDanger={false} />
      </a>
    </div>
  );
};

const CountdownTimer = ({ targetDate }) => {
  const [days, hours, minutes, seconds] = useCountdown(targetDate);

  if (days + hours + minutes + seconds <= 0) {
    return <ExpiredNotice />;
  } else {
    return (
      <ShowCounter
        days={days}
        hours={hours}
        minutes={minutes}
        seconds={seconds}
      />
    );
  }
};

export default CountdownTimer;
