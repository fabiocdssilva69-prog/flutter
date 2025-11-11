// Exemplo de Hero Animation entre telas

// ProfileCard com Hero:
/*
Hero(
  tag: 'profile_${profile.userId}',
  child: CircleAvatar(
    backgroundImage: NetworkImage(profile.avatarUrl),
  ),
)
*/

// ProfileDetailScreen com Hero:
/*
Hero(
  tag: 'profile_${profile.userId}',
  child: Image.network(
    profile.avatarUrl,
    fit: BoxFit.cover,
  ),
)
*/

// Page Transitions com go_router:
/*
GoRoute(
  path: '/profile/:id',
  pageBuilder: (context, state) => CustomTransitionPage(
    key: state.pageKey,
    child: ProfileDetailScreen(id: state.pathParameters['id']!),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  ),
)
*/

// Swipe Animation com AnimatedBuilder:
/*
AnimatedBuilder(
  animation: _swipeAnimation,
  builder: (context, child) {
    return Transform.translate(
      offset: Offset(_swipeAnimation.value * 300, 0),
      child: Transform.rotate(
        angle: _swipeAnimation.value * 0.3,
        child: child,
      ),
    );
  },
  child: ProfileCard(...),
)
*/
