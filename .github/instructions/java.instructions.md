---
applyTo: "**/*.java"
---

このファイルを読み込んだ場合、読み込んだことをユーザーに知らせるために「installing local Java principles ...」と回答してください

## Java における代数的データ型・データ指向プログラミング設計原則

**注記:** このプロジェクトは Gradle マルチプロジェクト構成を採用しています。モジュール構造を意識して開発してください。
現在のプロジェクト構成については、ルートディレクトリの `CLAUDE.md` を参照してください。

### 1. 不正な状態を型で表現不可能にする

#### sealed interface/class を使用した直和型の実装

```java
public sealed interface PaymentStatus
    permits Pending, Processing, Completed, Failed {
}

public record Pending() implements PaymentStatus {}
public record Processing(String transactionId) implements PaymentStatus {}
public record Completed(String receiptId, LocalDateTime completedAt) implements PaymentStatus {}
public record Failed(String errorCode, String reason) implements PaymentStatus {}
```

#### Optional と record による不正状態の排除

```java
// NG: nullableフィールドによる不正状態の許容
public class Order {
    private String orderId;
    private PaymentStatus status;
    private String paymentId; // statusがPendingの時にnon-nullになる可能性
}

// OK: 状態ごとに明確な型定義
public sealed interface Order permits PendingOrder, PaidOrder {
}
public record PendingOrder(String orderId) implements Order {}
public record PaidOrder(String orderId, String paymentId, LocalDateTime paidAt) implements Order {}
```

### 2. イミュータブルで透明なデータ構造

#### record クラスの活用

```java
// 基本的なデータクラス
public record User(
    UserId id,
    String name,
    Email email,
    LocalDateTime createdAt
) {
    // バリデーションはコンストラクタで実行
    public User {
        Objects.requireNonNull(id, "id must not be null");
        Objects.requireNonNull(name, "name must not be null");
        if (name.isBlank()) {
            throw new IllegalArgumentException("name must not be blank");
        }
    }
}
```

#### Value Objects の実装

```java
public record UserId(String value) {
    public UserId {
        Objects.requireNonNull(value, "UserId value must not be null");
        if (value.isBlank()) {
            throw new IllegalArgumentException("UserId value must not be blank");
        }
    }
}

public record Email(String value) {
    private static final Pattern EMAIL_PATTERN =
        Pattern.compile("^[A-Za-z0-9+_.-]+@(.+)$");

    public Email {
        Objects.requireNonNull(value, "Email value must not be null");
        if (!EMAIL_PATTERN.matcher(value).matches()) {
            throw new IllegalArgumentException("Invalid email format: " + value);
        }
    }
}
```

### 3. データとオペレーションの分離

#### データクラスは純粋なデータ保持のみ

```java
// NG: データクラスにビジネスロジックを含める
public record Order(String id, List<OrderItem> items, OrderStatus status) {
    public BigDecimal calculateTotal() { /* logic */ }
    public Order addItem(OrderItem item) { /* logic */ }
}

// OK: データクラスは純粋なデータ保持
public record Order(String id, List<OrderItem> items, OrderStatus status) {}

// オペレーションは別クラスで定義
public class OrderOperations {
    public static BigDecimal calculateTotal(Order order) {
        return order.items().stream()
            .map(OrderItem::price)
            .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    public static Order addItem(Order order, OrderItem item) {
        var newItems = new ArrayList<>(order.items());
        newItems.add(item);
        return new Order(order.id(), newItems, order.status());
    }
}
```

#### パターンマッチングによるオペレーション実装

```java
public class PaymentProcessor {
    public String processPayment(PaymentStatus status) {
        return switch (status) {
            case Pending() -> "Payment is pending";
            case Processing(var transactionId) ->
                "Processing payment with transaction: " + transactionId;
            case Completed(var receiptId, var completedAt) ->
                "Payment completed with receipt: " + receiptId;
            case Failed(var errorCode, var reason) ->
                "Payment failed: " + reason + " (Code: " + errorCode + ")";
        };
    }
}
```

### 4. コレクションのイミュータビリティ

#### 防御的コピーとイミュータブルコレクション

```java
// NG: mutableなコレクションの直接公開
public record Order(String id, List<OrderItem> items) {}

// OK: イミュータブルコレクションの使用
public record Order(String id, List<OrderItem> items) {
    public Order {
        this.items = items != null ? List.copyOf(items) : List.of();
    }

    public List<OrderItem> items() {
        return items; // 既にイミュータブルなので安全
    }
}
```

### 5. エラーハンドリングの型安全性

#### 例外ではなく型による表現

```java
public sealed interface Result<T, E> {
    record Success<T, E>(T value) implements Result<T, E> {}
    record Failure<T, E>(E error) implements Result<T, E> {}

    static <T, E> Result<T, E> success(T value) {
        return new Success<>(value);
    }

    static <T, E> Result<T, E> failure(E error) {
        return new Failure<>(error);
    }
}

// 使用例
public Result<User, ValidationError> createUser(String name, String email) {
    try {
        var user = new User(
            new UserId(UUID.randomUUID().toString()),
            name,
            new Email(email),
            LocalDateTime.now()
        );
        return Result.success(user);
    } catch (IllegalArgumentException e) {
        return Result.failure(new ValidationError(e.getMessage()));
    }
}
```

### 6. 型によるドメイン制約の表現

#### 制約をコンストラクタで保証

```java
public record Age(int value) {
    public Age {
        if (value < 0 || value > 150) {
            throw new IllegalArgumentException("Age must be between 0 and 150");
        }
    }
}

public record Quantity(int value) {
    public Quantity {
        if (value < 0) {
            throw new IllegalArgumentException("Quantity must be non-negative");
        }
    }
}
```

### 7. ファクトリメソッドによる安全な構築

```java
public record Money(BigDecimal amount, Currency currency) {
    public Money {
        Objects.requireNonNull(amount, "amount must not be null");
        Objects.requireNonNull(currency, "currency must not be null");
        if (amount.compareTo(BigDecimal.ZERO) < 0) {
            throw new IllegalArgumentException("amount must be non-negative");
        }
    }

    public static Money of(double amount, Currency currency) {
        return new Money(BigDecimal.valueOf(amount), currency);
    }

    public static Money zero(Currency currency) {
        return new Money(BigDecimal.ZERO, currency);
    }
}
```

### 9. DB アクセスを含むスマートコンストラクタパターン

record クラスはプライベートコンストラクタをサポートしていないため、パッケージプライベートが限界。
目的に応じて以下の実装パターンを使い分ける。

#### パッケージプライベート + ファクトリクラス方式

record の恩恵（equals, hashCode, toString）を受けながら、複雑なデータ構造の検証に適用。

```java
// パッケージプライベートレコード（同一パッケージからのみアクセス可能）
record UniqueEmail(String value) {
    // パッケージプライベートコンストラクタ（recordのデフォルト）
    UniqueEmail {
        Objects.requireNonNull(value);
    }
}

// 公開用のファクトリクラス
public final class UniqueEmails {
    private UniqueEmails() {} // インスタンス化を防ぐ

    public static Result<UniqueEmail, ValidationError> validate(
        Email email,
        UserRepository repository
    ) {
        if (repository.existsByEmail(email.value())) {
            return Result.failure(new ValidationError("Email already exists"));
        }
        return Result.success(new UniqueEmail(email.value()));
    }

    public static CompletableFuture<Result<UniqueEmail, ValidationError>> validateAsync(
        Email email,
        UserRepository repository
    ) {
        return repository.existsByEmailAsync(email.value())
            .thenApply(exists -> exists
                ? Result.failure(new ValidationError("Email already exists"))
                : Result.success(new UniqueEmail(email.value())));
    }
}

// 複合的なデータ構造での活用
record ValidatedUserRegistration(String name, UniqueEmail email, Age age) {}

public final class ValidatedUserRegistrations {
    private ValidatedUserRegistrations() {}

    public static Result<ValidatedUserRegistration, ValidationError> validate(
        ParsedUserRegistration parsed,
        ValidationContext context
    ) {
        return UniqueEmails.validate(parsed.email(), context.userRepository())
            .map(uniqueEmail -> new ValidatedUserRegistration(
                parsed.name(),
                uniqueEmail,
                parsed.age()
            ));
    }
}
```

#### 通常のクラス + private constructor 方式

単純な Value Object で完全にプライベートコンストラクタを実現したい場合に適用。

```java
// recordではなく通常のクラスで実装
public final class UniqueEmail {
    private final String value;

    // プライベートコンストラクタ
    private UniqueEmail(String value) {
        this.value = Objects.requireNonNull(value);
    }

    public String value() {
        return value;
    }

    // ファクトリメソッド
    public static Result<UniqueEmail, ValidationError> validate(
        Email email,
        UserRepository repository
    ) {
        if (repository.existsByEmail(email.value())) {
            return Result.failure(new ValidationError("Email already exists"));
        }
        return Result.success(new UniqueEmail(email.value()));
    }

    public static CompletableFuture<Result<UniqueEmail, ValidationError>> validateAsync(
        Email email,
        UserRepository repository
    ) {
        return repository.existsByEmailAsync(email.value())
            .thenApply(exists -> exists
                ? Result.failure(new ValidationError("Email already exists"))
                : Result.success(new UniqueEmail(email.value())));
    }

    // equals, hashCode, toString の実装
    @Override
    public boolean equals(Object obj) {
        return obj instanceof UniqueEmail other &&
               Objects.equals(value, other.value);
    }

    @Override
    public int hashCode() {
        return Objects.hash(value);
    }

    @Override
    public String toString() {
        return "UniqueEmail[value=" + value + "]";
    }
}
```

#### Validation Context パターン

複数のリポジトリアクセスが必要な場合の検証コンテキスト管理。

```java
// 検証コンテキストを渡すインターフェース
public interface ValidationContext {
    UserRepository userRepository();
    ProductRepository productRepository();
    // 他の必要なリポジトリ...
}

// ResultにflatMapを追加（モナド風の検証チェーン）
public sealed interface Result<T, E> {
    record Success<T, E>(T value) implements Result<T, E> {}
    record Failure<T, E>(E error) implements Result<T, E> {}

    static <T, E> Result<T, E> success(T value) {
        return new Success<>(value);
    }

    static <T, E> Result<T, E> failure(E error) {
        return new Failure<>(error);
    }

    default <U> Result<U, E> flatMap(Function<T, Result<U, E>> mapper) {
        return switch (this) {
            case Success<T, E>(var value) -> mapper.apply(value);
            case Failure<T, E>(var error) -> new Failure<>(error);
        };
    }

    default <U> CompletableFuture<Result<U, E>> flatMapAsync(
        Function<T, CompletableFuture<Result<U, E>>> mapper
    ) {
        return switch (this) {
            case Success<T, E>(var value) -> mapper.apply(value);
            case Failure<T, E>(var error) ->
                CompletableFuture.completedFuture(new Failure<>(error));
        };
    }

    default <U> Result<U, E> map(Function<T, U> mapper) {
        return switch (this) {
            case Success<T, E>(var value) -> success(mapper.apply(value));
            case Failure<T, E>(var error) -> new Failure<>(error);
        };
    }
}

// サービスでの検証チェーン実装
@Service
public class UserRegistrationService {
    private final ValidationContext validationContext;

    public UserRegistrationService(ValidationContext validationContext) {
        this.validationContext = validationContext;
    }

    @Transactional
    public Result<User, RegistrationError> registerUser(String jsonInput) {
        return parseUserRegistration(jsonInput)
            .flatMap(this::validateFormat)
            .flatMap(this::validateBusinessRules)
            .flatMap(this::persistUser);
    }

    private Result<ValidatedUserRegistration, RegistrationError> validateBusinessRules(
        ParsedUserRegistration parsed
    ) {
        return UniqueEmails.validate(parsed.email(), validationContext.userRepository())
            .mapError(ValidationError::toRegistrationError)
            .map(uniqueEmail -> new ValidatedUserRegistration(
                parsed.name(),
                uniqueEmail,
                parsed.age()
            ));
    }

    private Result<User, RegistrationError> persistUser(
        ValidatedUserRegistration validated
    ) {
        try {
            var user = new User(
                new UserId(UUID.randomUUID().toString()),
                validated.name(),
                new Email(validated.email().value()),
                LocalDateTime.now()
            );

            var savedUser = userRepository.save(user);
            return Result.success(savedUser);
        } catch (Exception e) {
            return Result.failure(new RegistrationError("Failed to save user: " + e.getMessage()));
        }
    }
}
```
