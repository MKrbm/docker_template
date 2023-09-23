import random

def play_game():
    board = [' '] * 9
    player = 'X'
    computer = 'O'

    while True:
        print_board(board)
        move = get_player_move(board, player)
        make_move(board, player, move)

        if is_winner(board, player):
            print('You win!')
            break

        move = get_computer_move(board, computer)
        make_move(board, computer, move)

        if is_winner(board, computer):
            print('The computer wins!')
            break

def print_board(board):
    print('   |   |')
    print(' ' + board[0] + ' | ' + board[1] + ' | ' + board[2])
    print('   |   |')
    print('-----------')
    print('   |   |')
    print(' ' + board[3] + ' | ' + board[4] + ' | ' + board[5])
    print('   |   |')
    print('-----------')
    print('   |   |')
    print(' ' + board[6] + ' | ' + board[7] + ' | ' + board[8])
    print('   |   |')

def get_player_move(board, player):
    while True:
        move = input('Enter your move (0-8): ')
        try:
            move = int(move)
        except ValueError:
            print('Please enter a number between 0 and 8.')
            continue

        if move < 0 or move > 8:
            print('Please enter a number between 0 and 8.')
            continue

        if board[move] != ' ':
            print('That space is already occupied. Please choose another space.')
            continue

        return move

def get_computer_move(board, computer):
    best_moves = [0, 1, 2, 3, 4, 5, 6, 7, 8]
    random.shuffle(best_moves)

    for move in best_moves:
        if board[move] == ' ':
            return move

def make_move(board, player, move):
    board[move] = player

def is_winner(board, player):
    return ((board[0] == player and board[1] == player and board[2] == player) or
            (board[3] == player and board[4] == player and board[5] == player) or
            (board[6] == player and board[7] == player and board[8] == player) or
            (board[0] == player and board[3] == player and board[6] == player) or
            (board[1] == player and board[4] == player and board[7] == player) or
            (board[2] == player and board[5] == player and board[8] == player) or
            (board[0] == player and board[4] == player and board[8] == player) or
            (board[2] == player and board[4] == player and board[6] == player))

play_game()