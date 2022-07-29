# plumb5-sdk

sdk

## Install

```bash
npm install plumb5-sdk
npx cap sync
```

## API

<docgen-index>

* [`echo(...)`](#echo)
* [`initializePlumb5()`](#initializeplumb5)
* [`deviceRegistration()`](#deviceregistration)
* [`setUserDetails(...)`](#setuserdetails)
* [`tracking(...)`](#tracking)
* [`pushResponse(...)`](#pushresponse)
* [`eventPost(...)`](#eventpost)
* [Interfaces](#interfaces)

</docgen-index>

<docgen-api>
<!--Update the source file JSDoc comments and rerun docgen to update the docs below-->

### echo(...)

```typescript
echo(options: { value: string; }) => Promise<{ value: string; }>
```

| Param         | Type                            |
| ------------- | ------------------------------- |
| **`options`** | <code>{ value: string; }</code> |

**Returns:** <code>Promise&lt;{ value: string; }&gt;</code>

--------------------


### initializePlumb5()

```typescript
initializePlumb5() => Promise<void>
```

--------------------


### deviceRegistration()

```typescript
deviceRegistration() => Promise<void>
```

--------------------


### setUserDetails(...)

```typescript
setUserDetails(options: UserOptions) => Promise<void>
```

| Param         | Type                                                |
| ------------- | --------------------------------------------------- |
| **`options`** | <code><a href="#useroptions">UserOptions</a></code> |

--------------------


### tracking(...)

```typescript
tracking(options: { ScreenName: string; PageParameter: any; }) => Promise<void>
```

| Param         | Type                                                     |
| ------------- | -------------------------------------------------------- |
| **`options`** | <code>{ ScreenName: string; PageParameter: any; }</code> |

--------------------


### pushResponse(...)

```typescript
pushResponse(options: { ScreenName: string; PageParameter: any; }) => Promise<void>
```

| Param         | Type                                                     |
| ------------- | -------------------------------------------------------- |
| **`options`** | <code>{ ScreenName: string; PageParameter: any; }</code> |

--------------------


### eventPost(...)

```typescript
eventPost(options: EventDetails) => Promise<void>
```

| Param         | Type                                                  |
| ------------- | ----------------------------------------------------- |
| **`options`** | <code><a href="#eventdetails">EventDetails</a></code> |

--------------------


### Interfaces


#### UserOptions

| Prop                | Type                |
| ------------------- | ------------------- |
| **`Name`**          | <code>string</code> |
| **`EmailId`**       | <code>string</code> |
| **`PhoneNumber`**   | <code>string</code> |
| **`LeadType`**      | <code>number</code> |
| **`Gender`**        | <code>string</code> |
| **`Age`**           | <code>string</code> |
| **`AgeRange`**      | <code>string</code> |
| **`MaritalStatus`** | <code>string</code> |
| **`Education`**     | <code>string</code> |
| **`Occupation`**    | <code>string</code> |
| **`Interests`**     | <code>string</code> |
| **`Location`**      | <code>string</code> |


#### EventDetails

| Prop              | Type                |
| ----------------- | ------------------- |
| **`Type`**        | <code>string</code> |
| **`Name`**        | <code>string</code> |
| **`PhoneNumber`** | <code>string</code> |
| **`Value`**       | <code>number</code> |

</docgen-api>
# plumb5-sdk
