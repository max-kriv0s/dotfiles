"""LSP: basedpyright (типы) и ruff (линтер).

Проверять: K на print показывает документацию от basedpyright, а не пустоту.
Форматирование: ruff. Ошибка ниже должна подсветиться линтером.
"""

from dataclasses import dataclass


@dataclass
class User:
    id: int
    name: str
    active: bool


def active_names(users: list[User]) -> list[str]:
    return [user.name for user in users if user.active]


seed = [
    User(id=1, name="Мария", active=True),
    User(id=2, name="Иван", active=False),
]

print(active_names(seed))

# Намеренная ошибка: переменная не определена
print(undefined_name)
