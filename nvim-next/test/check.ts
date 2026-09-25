// LSP: vtsls, eslint. Форматирование: prettierd. Линтер: eslint_d.
// Проверять: gd, gR, K, <leader>ca, <leader>rn, <leader>uh, vaf/vif

export interface User {
  id: number;
  name: string;
  active: boolean;
}

export function findUser(users: User[], id: number): User | undefined {
  return users.find((user) => user.id === id);
}

export function activeNames(users: User[]): string[] {
  const active = users.filter((user) => user.active);
  return active.map((user) => user.name);
}

// Для <leader>uh: слева от = должен появиться серый ": User[]"
const seed = [
  { id: 1, name: "Мария", active: true },
  { id: 2, name: "Иван", active: false },
];

// Намеренная ошибка для проверки диагностик: аргумент не того типа
const wrong = findUser(seed, "1");
