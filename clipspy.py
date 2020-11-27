from clips import Environment, Symbol

environment = Environment()

# load constructs into the environment
environment.load('cam.clp')

environment.reset()
iter = environment.run()
print(iter)

environment.reset()

for i in range(1):
    environment.run(limit=1)
    for fact in environment.facts():
        print(fact)

    print('_______________________')

