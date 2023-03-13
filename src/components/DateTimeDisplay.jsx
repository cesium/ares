import React from "react";

const DateTimeDisplay = ({ value, isDanger }) => {
  return (
    <div className={isDanger ? "text-red-600" : "text-white"}>
      {value < 10 ? `0${value}` : value}
    </div>
  );
};

export default DateTimeDisplay;
