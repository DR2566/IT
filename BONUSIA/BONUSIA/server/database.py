import mysql.connector
import json
from datetime import datetime
import time

class DATABASE:
    def __init__(self, host="localhost", user="bonusia_client", password="67&((#fef24c))3$#^6a", database_name="BONUSIA"):
        self.host = host
        self.user = user
        self.password = password
        self.database_name = database_name

    # -----------------------------   CONNECTION   -----------------------------------
    def get_connection(self):
        retries = 3  # Retry connecting 3 times
        while retries:
            try:
                # Create a new connection each time
                connection = mysql.connector.connect(
                    host=self.host,
                    user=self.user,
                    password=self.password,
                    database=self.database_name
                )
                return connection
            except mysql.connector.Error as err:
                retries -= 1
                time.sleep(1)  # Wait before retrying
        raise Exception("Failed to establish a database connection after multiple attempts.")
    
    
    def execute_query(self, query, params=None, dictionary_bool=False):
        try:
            connection = self.get_connection()
            cursor = connection.cursor(dictionary=dictionary_bool)
            
            if params:
                cursor.execute(query, params)
            else:
                cursor.execute(query)
            
            # Commit the changes for non-SELECT queries
            if query.strip().lower().startswith('select'):
                response = cursor.fetchall()
            elif query.strip().lower().startswith('update'):
                connection.commit()
                response = cursor.rowcount  # Number of affected rows
            else:
                connection.commit()
                response = cursor.lastrowid  # Number of affected rows
            
            cursor.close()
            connection.close()
            return 1, response
        
        except mysql.connector.Error as err:
            return 0, err
        
        except Exception as e:
            return 0, e
    
class BaseModel:
    
    @classmethod
    def create(cls, **kwargs):
        # Dynamically generate SQL for creating a new entry
        columns = ', '.join(kwargs.keys())
        values = ', '.join(['%s'] * len(kwargs))
        sql = f"INSERT INTO `{cls.table_name}`({columns}) VALUES({values});"
        params = tuple(kwargs.values())
        
        status, res = database.execute_query(sql, params)
        if status == 0:
            return res
        id = res  # Assuming the response contains the inserted ID

        # Instantiate and return a new object
        return cls(id, **kwargs)

    @classmethod
    def get(cls, **kwargs):
        attribute_name=  list(kwargs.keys())[0]
        attribute_value = list(kwargs.values())[0]
        # Dynamically generate SQL for fetching an entry by ID
        sql = f"SELECT * FROM `{cls.table_name}` WHERE {attribute_name} = %s;"
        params = (attribute_value,)
        
        status, res = database.execute_query(sql, params, dictionary_bool=True)
        if status == 0:
            print(res)
            return
        
        if len(res) > 1:
            obj_list = [cls(**obj_dict) for obj_dict in res]
            return obj_list
        elif len(res) == 1:
            obj_dict = res[0]
            return cls(**obj_dict)
        else:
            return None

    @classmethod
    def get_all(cls):
        # Dynamically generate SQL for fetching all entries
        sql = f"SELECT * FROM `{cls.table_name}`;"
        
        status, res = database.execute_query(sql, dictionary_bool=True)
        if status == 0:
            print(res)
            return
        
        # Return a list of instantiated objects
        obj_list = [cls(**obj_dict) for obj_dict in res]
        return obj_list

    def save(self):
        # Dynamically generate SQL for updating an existing entry
        attributes = vars(self)
        columns = ', '.join([f"{key} = %s" for key in attributes if key != 'id'])
        params = tuple(getattr(self, key) for key in attributes if key != 'id') + (self.id,)
        
        sql = f"UPDATE `{self.table_name}` SET {columns} WHERE id = %s;"
        
        status, res = database.execute_query(sql, params)
        return res
    
    def __repr__(self):
        return str(vars(self))


# BONUSIA Models
class User(BaseModel):
    table_name = "User"

    def __init__(self, id=None, name=None, total_balance=None, bank_balance=None, game_balance=None):
        self.id = id
        self.name = name
        self.total_balance = total_balance
        self.bank_balance = bank_balance
        self.game_balance = game_balance

class BettingShop(BaseModel):
    table_name = "BettingShop"

    def __init__(self, id=None, name=None):
        self.id = id
        self.name = name

class BankAccount(BaseModel):
    table_name = "BankAccount"

    def __init__(self, id=None, owner=None, bankID=None):
        self.id = id
        self.owner = owner
        self.bankID = bankID

class GameAccount(BaseModel):
    table_name = "GameAccount"

    def __init__(self, id=None, owner=None, balance=None, bankAccount=None, bettingShop=None):
        self.id = id
        self.owner = owner
        self.balance = balance
        self.bankAccount = bankAccount
        self.bettingShop = bettingShop

class BankBalance(BaseModel):
    table_name = "BankBalance"

    def __init__(self, id=None, user=None, balance=None, bankAccount=None):
        self.id = id
        self.user = user
        self.balance = balance
        self.bankAccount = bankAccount

class TransactionType(BaseModel):
    table_name = "TransactionType"

    def __init__(self, id=None, name=None):
        self.id = id
        self.name = name

class Transaction(BaseModel):
    table_name = "Transaction"

    def __init__(self, id=None, transactionType=None, user=None, amount=None):
        self.id = id
        self.transactionType = transactionType
        self.user = user
        self.amount = amount

class BankBalanceHistory(BaseModel):
    table_name = "BankBalanceHistory"

    def __init__(self, id=None, date=None, bankBalance=None, amount=None):
        self.id = id
        self.date = date
        self.bankBalance = bankBalance
        self.amount = amount

class GameBalanceHistory(BaseModel):
    table_name = "GameBalanceHistory"

    def __init__(self, id=None, date=None, gameAccount=None, amount=None):
        self.id = id
        self.date = date
        self.gameAccount = gameAccount
        self.amount = amount

class UserHistory(BaseModel):
    table_name = "UserHistory"

    def __init__(self, id=None, user=None, total_balance=None, bank_balance=None, game_balance=None):
        self.id = id
        self.user = user
        self.total_balance = total_balance
        self.bank_balance = bank_balance
        self.game_balance = game_balance


# Instantiate the database
database = DATABASE()


# User.create(name="Krystof", total_balance=0.00, bank_balance=0.00, game_balance=0.00)
# User.create(name="David", total_balance=22325.40, bank_balance=305.00, game_balance=22020.40)
# User.create(name="Ilona", total_balance=4098.23, bank_balance=4089.67, game_balance=8.56)

# BettingShop.create(name="Betano")
# BettingShop.create(name="Sazka")
# BettingShop.create(name="Tipsport")
# BettingShop.create(name="Kingsbet")
# BettingShop.create(name="Synottip")
# BettingShop.create(name="Merkur")
# BettingShop.create(name="MagicPlanet")
# BettingShop.create(name="Admiral")
# BettingShop.create(name="Bonver")

# BankAccount.create(Owner="David", bankID="0100")
# BankAccount.create(Owner="Ilona", bankID="2010")
# BankAccount.create(Owner="David", bankID="NeteraPay")

# GameAccount.create(Owner="David", balance=0.20, BankAccount=1, BettingShop="Betano")
# GameAccount.create(Owner="David", balance=10.40, BankAccount=1, BettingShop="Sazka")
# GameAccount.create(Owner="David", balance=4.50, BankAccount=1, BettingShop="Tipsport")
# GameAccount.create(Owner="David", balance=0.10, BankAccount=1, BettingShop="Kingsbet")
# GameAccount.create(Owner="David", balance=11000.00, BankAccount=1, BettingShop="Synottip")
# GameAccount.create(Owner="David", balance=5.20, BankAccount=1, BettingShop="Merkur")
# GameAccount.create(Owner="David", balance=0.00, BankAccount=1, BettingShop="MagicPlanet")
# GameAccount.create(Owner="David", balance=0.00, BankAccount=3, BettingShop="Admiral")
# GameAccount.create(Owner="David", balance=0.00, BankAccount=1, BettingShop="Bonver")
# GameAccount.create(Owner="David", balance=0.00, BankAccount=1, BettingShop="LuckyBet")
# GameAccount.create(Owner="David", balance=0.00, BankAccount=1, BettingShop="Maxa")
# GameAccount.create(Owner="Ilona", balance=0.56, BankAccount=2, BettingShop="Betano")
# GameAccount.create(Owner="Ilona", balance=8.00, BankAccount=2, BettingShop="Sazka")
# GameAccount.create(Owner="Ilona", balance=0.00, BankAccount=2, BettingShop="Kingsbet")
# GameAccount.create(Owner="Ilona", balance=11000.00, BankAccount=2, BettingShop="Synottip")
# GameAccount.create(Owner="Ilona", balance=0.00, BankAccount=2, BettingShop="Bonver")

# BankBalance.create(User="David", balance=305.00, BankAccount=1)
# BankBalance.create(User="Krystof", balance=0.00, BankAccount=1)
# BankBalance.create(User="David", balance=0.00, BankAccount=2)
# BankBalance.create(User="Ilona", balance=4089.67, BankAccount=2)
# BankBalance.create(User="Krystof", balance=0.00, BankAccount=2)
# BankBalance.create(User="Krystof", balance=0.00, BankAccount=3)
# BankBalance.create(User="David", balance=0.00, BankAccount=3)


# TransactionType.create(name="OUTSIDE->BANK")
# TransactionType.create(name="OUTSIDE->BETTING_SHOP")