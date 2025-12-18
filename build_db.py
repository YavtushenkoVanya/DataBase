import sqlite3

print("START")

# читаємо SQL
with open("exam.sql", "r", encoding="utf-8", errors="ignore") as f:
    sql = f.read()

print("SQL LOADED")

# створюємо базу
conn = sqlite3.connect("exam.db")
print("DB CONNECTED")

conn.executescript(sql)
conn.commit()
print("SQL EXECUTED")

# перевірка
cur = conn.cursor()
cur.execute("SELECT COUNT(*) FROM sqlite_master WHERE type='table'")
print("TABLES:", cur.fetchone()[0])

conn.close()
print("DONE")
