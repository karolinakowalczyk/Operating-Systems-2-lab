import random


def display_board(board):
    empty_board = """
___________________
|     |     |     |
|  7  |  8  |  9  |
|     |     |     |
|-----------------|
|     |     |     |
|  4  |  5  |  6  |
|     |     |     |
|-----------------|
|     |     |     |
|  1  |  2  |  3  |
|     |     |     |
|-----------------|
"""

    for i in range(1, 10):
        if board[i] == 'O' or board[i] == 'X':
            empty_board = empty_board.replace(str(i), board[i])
        else:
            empty_board = empty_board.replace(str(i), ' ')
    print(empty_board)


def user_choice():
    gamer = input("Podaj czym chcesz grać - 'O' albo 'X' ")
    while True:
        if gamer.upper() == 'X':
            computer = 'O'
            print("Jesteś: " + gamer + ". Komputer jest: " + computer + ".")
            return gamer.upper(), computer
        elif gamer.upper() == 'O':
            computer = 'X'
            print("Jesteś: " + gamer + ". Komputer jest: " + computer + ".")
            return gamer.upper(), computer
        else:
            gamer = input("Podaj poprawny znak: ")


def take_field(board, mark, field):
    board[field] = mark


def field_availability(board, field):
    return board[field] == '#'


def full_board_check(board):
    return len([i for i in board if i == '#']) == 1


def win_check(board, mark):
    if board[1] == board[2] == board[3] == mark:
        return True
    if board[4] == board[5] == board[6] == mark:
        return True
    if board[7] == board[8] == board[9] == mark:
        return True
    if board[1] == board[4] == board[7] == mark:
        return True
    if board[2] == board[5] == board[8] == mark:
        return True
    if board[3] == board[6] == board[9] == mark:
        return True
    if board[1] == board[5] == board[9] == mark:
        return True
    if board[3] == board[5] == board[7] == mark:
        return True
    return False


def player_movement(board):
    choice = input("Wybierz wolne pole od 1 do 9 : ")
    while not (1 <= int(choice) <= 9):
        choice = input("Podaj poprawną liczbę : ")
    while not field_availability(board, int(choice)):
        choice = input("To pole jest zajęte. Wybierz wolne pole : ")
        while not (1 <= int(choice) <= 9):
            choice = input("Podaj poprawną liczbę : ")
    return choice


def duplicate_board(board):
    copy_board = []
    for field in board:
        copy_board.append(field)
    return copy_board


def rand_movement(board, fields):
    available_fields = []
    for i in fields:
        if field_availability(board, i):
            available_fields.append(i)

    if len(available_fields) != 0:
        return random.choice(available_fields)
    else:
        return None


def computer_movement(board, mark):
    if mark == 'X':
        gamer = 'O'
    else:
        gamer = 'X'

    for i in range(1, 10):
        copy = duplicate_board(board)
        if field_availability(copy, i):
            take_field(copy, mark, i)
            if win_check(copy, mark):
                return i

    for i in range(1, 10):
        copy = duplicate_board(board)
        if field_availability(copy, i):
            take_field(copy, gamer, i)
            if win_check(copy, gamer):
                return i

    move = rand_movement(board, [1, 3, 7, 9])
    if move is not None:
        return move

    if field_availability(board, 5):
        return 5

    return rand_movement(board, [2, 4, 6, 8])


def rand_order():
    if random.randint(0, 1) != 0:
        return 'gamer'
    else:
        return 'computer'


def play_again():
    question = input("Chcesz zagrać ponownie (t/n) ? ")
    if question.lower() == 't':
        return True
    if question.lower() == 'n':
        return False


if __name__ == "__main__":
    print("Kółko i krzyżyk.")
    i = 1
    players = user_choice()
    turn = rand_order()
    print('Zaczyna: ' + turn + ' .')
    board = ['#'] * 10
    while True:
        full_board = full_board_check(board)
        while not full_board:
            if turn == 'gamer':
                mark = players[0]
                field = player_movement(board)
                take_field(board, mark, int(field))
                display_board(board)
                if win_check(board, mark):
                    print("Wygrałeś !")
                    break
                turn = 'computer'
            else:
                mark = players[1]
                field = computer_movement(board, mark)
                take_field(board, mark, int(field))
                display_board(board)
                if win_check(board, mark):
                    print("Przegrałeś !")
                    break
                turn = 'gamer'
            i += 1
            full_board = full_board_check(board)
        if full_board:
            print("Remis !")
        if not play_again():
            break
        else:
            i = 1
            players = user_choice()
            board = ['#'] * 10
