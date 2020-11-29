from clips import Environment, Symbol

class ClipsMinesweeper():
    def __init__(self):
        self.environment = Environment()

        # load constructs into the environment
        self.environment.load('minesweeper.clp')

    def load_board(self, size, num_bombs):
        template_board = self.environment.find_template('board')
        new_board = template_board.new_fact()
        
        new_board['size'] = size
        new_board['remaining-bomb'] = num_bombs
        new_board.assertit()

    def load_square(self, board_state):
        template_square = self.environment.find_template('square')
        for col in range(len(board_state)):
            for row in range(len(board_state[col])):
                new_square = template_square.new_fact()

                new_square['x'] = row
                new_square['y'] = col
                new_square['value'] = board_state[col][row]
                new_square.assertit()

    def print_facts(self):
        for fact in self.environment.facts():
            print(fact)

# environment.reset()
# load_board(10, 8)
# iter = environment.run()
# print(iter)

# environment.reset()

# for i in range(1):
#     environment.run(limit=1)
#     for fact in environment.facts():
#         print(fact)

#     print('_______________________')

