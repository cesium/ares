import React from "react";

const DateTimeDisplay = ({ value, isDanger }) => {
  return (
    <div className={isDanger ? "countdown danger" : "countdown"}>
      {value < 10 ? `0${value}` : value}
    </div>
  );
};

export default DateTimeDisplay;
