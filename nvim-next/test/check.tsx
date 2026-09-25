// React. Проверять: автозакрытие тегов, gcc внутри JSX даёт {/* */},
// а на строке с function — обычный //

import { useState } from "react";

interface CounterProps {
  title: string;
  step?: number;
}

export function Counter({ title, step = 1 }: CounterProps) {
  const [count, setCount] = useState(0);

  return (
    <div className="counter">
      <h2>{title}</h2>
      <span>{count}</span>
      <button onClick={() => setCount(count + step)}>Прибавить</button>
    </div>
  );
}
