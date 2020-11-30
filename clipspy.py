from clips import Environment, Symbol
class ClipsMinesweeper():
    def __init__(self):
        self.environment = Environment()
        

        # load constructs into the environment
        self.environment.load('minesweeper.clp')
        self.environment.reset()

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
                closed_square_around = 8
                if col == 0 or col == len(board_state) - 1:
                    closed_square_around -= 3
                
                if row == 0 or row == len(board_state) - 1:
                    closed_square_around -= 3
                    if col == 0 or col == len(board_state) - 1:
                        closed_square_around += 1

                new_square['x'] = row
                new_square['y'] = col
                new_square['value'] = board_state[col][row]
                new_square['closed-square-around'] = closed_square_around
                # if col == 0 and row == 0:
                #     new_square['is-open']
                new_square.assertit()

    def print_facts(self):
        print('ke sini')
        template_square = self.environment.find_template('square')
        template_board = self.environment.find_template('board')
        for fact in self.environment.facts():
            if fact.template == template_square: 
                print(fact['x'], fact['y'])
            elif fact.template == template_board:
                print(fact['remaining-bomb'])

    def run_one_step(self):
        self.environment.run(limit=1)
        template_square = self.environment.find_template('square')
        template_board = self.environment.find_template('board')
        square_fact = []
        board_fact = template_board.new_fact()
        
            
        return self.environment.facts()
