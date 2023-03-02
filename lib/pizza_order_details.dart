import 'package:flutter/material.dart';

import 'package:pizza/ingredient.dart';

const pizzaCardSize = 55.0;

class PizzaOrderDetails extends StatefulWidget {
  const PizzaOrderDetails({super.key});
  @override
  PizzaOrderDetailsState createState() => PizzaOrderDetailsState();
}

class PizzaOrderDetailsState extends State<PizzaOrderDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // ignore: prefer_const_constructors
        title: const Text(
          'Pizzaria Napoles',
          style: TextStyle(
            color: Colors.brown,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 5,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.shopping_cart_outlined,
              color: Colors.brown,
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            bottom: 50,
            left: 10,
            right: 10,
            top: 8,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 10,
              child: Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: PizzaDetails(),
                  ),
                  Expanded(
                    flex: 2,
                    child: _PizzaIngredients(),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 25,
            width: pizzaCardSize,
            height: pizzaCardSize,
            left: MediaQuery.of(context).size.width / 2 - pizzaCardSize / 2,
            child: PizzaCardButton(
              onTap: () {
                print('card');
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PizzaDetails extends StatefulWidget {
  const PizzaDetails({super.key});

  @override
  State<PizzaDetails> createState() => PizzaDetailsState();
}

class PizzaDetailsState extends State<PizzaDetails>
    with SingleTickerProviderStateMixin {
  AnimationController? animationController;
  final List _listIngredients = <Ingredient?>[];
  int total = 15;
  final notifierFoculs = ValueNotifier(false);
  List<Animation> animationList = <Animation>[];
  BoxConstraints? pizzaConstrains;

  Widget buildIngredientWidget() {
    List<Widget> elements = [];
    if (animationList.isNotEmpty) {
      for (int i = 0; i < _listIngredients.length; i++) {
        Ingredient ingredient = _listIngredients[i];
        final ingredientWidget = Image.asset(
          ingredient.image,
          height: 40,
        );
        for (int j = 0; j < ingredient.positions.length; j++) {
          final animation = animationList[j];
          final position = ingredient.positions[j];
          final positionX = position.dx;
          final positionY = position.dy;

          if (i == _listIngredients.length - 1) {
            double fromX = 0.0, fromY = 0.0;
            if (j < 1) {
              fromX = -pizzaConstrains!.maxWidth * (1 - animation.value);
            } else if (j < 2) {
              fromX = pizzaConstrains!.maxWidth * (1 - animation.value);
            } else if (j < 4) {
              fromY = -pizzaConstrains!.maxWidth * (1 - animation.value);
            } else {
              fromY = pizzaConstrains!.maxWidth * (1 - animation.value);
            }

            final opacity = animation.value;

            if (animation.value > 0) {
              elements.add(
                Opacity(
                  opacity: opacity,
                  child: Transform(
                      transform: Matrix4.identity()
                        ..translate(
                          fromX + pizzaConstrains!.maxWidth * positionX,
                          fromY + pizzaConstrains!.maxHeight * positionY,
                        ),
                      child: ingredientWidget),
                ),
              );
            }
          } else {
            elements.add(
              Transform(
                  transform: Matrix4.identity()
                    ..translate(
                      pizzaConstrains!.maxWidth * positionX,
                      pizzaConstrains!.maxHeight * positionY,
                    ),
                  child: ingredientWidget),
            );
          }
        }
      }
      return Stack(
        children: elements,
      );
    }
    return SizedBox.fromSize();
  }

  void buildeIngredientsAnimation() {
    animationList.clear();
    animationList.add(
      CurvedAnimation(
          curve: Interval(0.0, 0.8, curve: Curves.decelerate),
          parent: animationController!),
    );
    animationList.add(
      CurvedAnimation(
          curve: Interval(0.2, 0.8, curve: Curves.decelerate),
          parent: animationController!),
    );
    animationList.add(
      CurvedAnimation(
          curve: Interval(0.4, 1.0, curve: Curves.decelerate),
          parent: animationController!),
    );
    animationList.add(
      CurvedAnimation(
          curve: Interval(0.1, 0.7, curve: Curves.decelerate),
          parent: animationController!),
    );
    animationList.add(
      CurvedAnimation(
          curve: Interval(0.3, 1.0, curve: Curves.decelerate),
          parent: animationController!),
    );
  }

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    super.initState();
  }

  @override
  void dispose() {
    animationController!.dispose();
    super.dispose();
  }

  Widget build(
    BuildContext context,
  ) {
    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: DragTarget<Ingredient>(
                onAccept: (ingredient) {
                  print('onAccepy');

                  notifierFoculs.value = false;
                  setState(() {
                    _listIngredients.add(ingredient);
                    total++;
                  });
                  buildeIngredientsAnimation();
                  animationController!.forward(from: 0.0);
                },
                onWillAccept: (ingredient) {
                  print('onwillAccept');

                  notifierFoculs.value = true;

                  for (Ingredient i in _listIngredients) {
                    if (i.compare(ingredient!)) {
                      return false;
                    }
                  }

                  return true;
                },
                onLeave: (ingredient) {
                  print('onleav');
                  notifierFoculs.value = false;
                },
                builder: (context, list, rejects) {
                  return LayoutBuilder(builder: (context, constraints) {
                    pizzaConstrains = constraints;
                    return Center(
                      child: ValueListenableBuilder<bool>(
                          valueListenable: notifierFoculs,
                          builder: (context, foculs, _) {
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 400),
                              height: foculs
                                  ? constraints.maxHeight
                                  : constraints.maxHeight - 10,
                              child: Stack(
                                children: [
                                  Image.asset('images/dish.png'),
                                  Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Image.asset('images/pizza-1.png'),
                                  ),
                                ],
                              ),
                            );
                          }),
                    );
                  });
                },
              ),
            ),
            const SizedBox(height: 5),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                      position: animation.drive(Tween<Offset>(
                        begin: Offset(0.0, 0.0),
                        end: Offset(0.0, animation.value),
                      )),
                      child: child),
                );
              },
              child: Text(
                '\$${total}',
                key: UniqueKey(),
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
              ),
            ),
          ],
        ),
        AnimatedBuilder(
            animation: animationController!,
            builder: (context, _) {
              return buildIngredientWidget();
            })
      ],
    );
  }
}

class PizzaCardButton extends StatefulWidget {
  const PizzaCardButton({super.key, required this.onTap});

  final VoidCallback onTap;
  @override
  _PizzaCardButtonState createState() => _PizzaCardButtonState();
}

class _PizzaCardButtonState extends State<PizzaCardButton>
    with SingleTickerProviderStateMixin {
  AnimationController? animationController;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      lowerBound: 1.0,
      upperBound: 1.5,
      duration: const Duration(microseconds: 150),
      reverseDuration: const Duration(milliseconds: 200),
    );
    super.initState();
  }

  @override
  void dispose() {
    animationController!.dispose();
    super.dispose();
  }

  Future<void> animatedBotton() async {
    await animationController!.forward(from: 0.0);
    await animationController!.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          widget.onTap();
          animatedBotton();
        },
        child: AnimatedBuilder(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.orange.withOpacity(0.5),
                  Colors.orange,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 15.0,
                  offset: Offset(0.0, 4.0),
                  spreadRadius: 4.0,
                )
              ],
            ),
            child: const Icon(
              Icons.shopping_cart_outlined,
              color: Colors.white,
              size: 35,
            ),
          ),
          animation: animationController!,
          builder: (context, child) {
            return Transform.scale(
              scale: (2 - animationController!.value),
              child: child,
            );
          },
        ));
  }
}

class _PizzaIngredients extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: ingredients.length,
      itemBuilder: (context, index) {
        final ingredient = ingredients[index];
        return PizzaIngredientsItem(ingredient: ingredient);
      },
    );
  }
}

class PizzaIngredientsItem extends StatelessWidget {
  const PizzaIngredientsItem({super.key, required this.ingredient});
  final Ingredient ingredient;

  @override
  Widget build(BuildContext context) {
    final child = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 7.0),
      child: Container(
          height: 60,
          width: 60,
          decoration: const BoxDecoration(
            color: Color(0xFFF5EED3),
            shape: BoxShape.circle,
          ),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Image.asset(
              ingredient.image,
              fit: BoxFit.contain,
            ),
          )),
    );
    return Center(
      child: Draggable(
        feedback: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                blurRadius: 10.0,
                color: Colors.black26,
                offset: Offset(0.0, 5.0),
                spreadRadius: 5.0,
              ),
            ],
          ),
          child: child,
        ),
        data: ingredient,
        child: child,
      ),
    );
  }
}
