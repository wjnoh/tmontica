import * as React from "react";
import { Link, withRouter, RouteComponentProps } from "react-router-dom";
import moment from "moment";
import * as userTypes from "../../types/user";
import "./styles.scss";
import { checkDuplicated } from "../../api/user";
import { CommonError } from "../../api/CommonError";
import { handleError } from "../../api/common";

export interface ISignupFormProps extends RouteComponentProps {
  fetchSignup(userInfo: userTypes.IUserSignupInfo): void;
  isSignupLoading: boolean;
}

export interface ISignupFormState {
  id: string;
  password: string;
  passwordCheck: string;
  name: string;
  email: string;
  birthDate: string;
  isIdOk: boolean;
  isIdNotSame: boolean;
  isPasswordOk: boolean;
  isPasswordSame: boolean;
}

export interface InputState {
  id: string;
  password: string;
  passwordCheck: string;
  name: string;
  email: string;
  birthDate: string;
}

class SignupForm extends React.PureComponent<ISignupFormProps, ISignupFormState> {
  state = {
    id: "",
    password: "",
    passwordCheck: "",
    name: "",
    email: "",
    birthDate: "",
    isIdOk: false,
    isIdNotSame: false,
    isPasswordOk: false,
    isPasswordSame: false
  };

  // 인풋 핸들링하는 함수.
  handleInputChange = (e: React.FormEvent<HTMLInputElement>) => {
    this.setState(
      {
        [e.currentTarget.name]: e.currentTarget.value
      } as { [K in keyof InputState]: InputState[K] },
      () => {
        const { password, passwordCheck } = this.state;

        // 패스워드 정규식, 일치 검사
        if (/^(?=.*[a-zA-Z])(?=.*[!@#$%^*+=-])(?=.*[0-9]).{6,19}/.test(password)) {
          this.setState({
            isPasswordOk: true
          });
          if (password === passwordCheck) {
            this.setState({
              isPasswordSame: true
            });
          } else {
            this.setState({
              isPasswordSame: false
            });
          }
        } else {
          this.setState({
            isPasswordOk: false
          });
        }
      }
    );
  };

  // 중복확인 때문에 아이디만 핸들링 함수 분리.
  handleIdInputChange = (e: React.FormEvent<HTMLInputElement>) => {
    this.setState(
      {
        id: e.currentTarget.value
      },
      () => {
        const { id } = this.state;

        // 아이디 정규식 검사
        if (/^[a-z0-9]{6,19}$/.test(id)) {
          this.setState({
            isIdOk: true,
            isIdNotSame: false
          });
        } else {
          this.setState({
            isIdOk: false,
            isIdNotSame: false
          });
        }
      }
    );
  };

  // 중복확인 API 호출 함수.
  handleIsIdNotSame = async () => {
    try {
      const { id, isIdOk } = this.state;

      if (isIdOk) {
        const data = await checkDuplicated(id);
        if (data instanceof CommonError) {
          throw data;
        }
        this.setState({
          isIdNotSame: true
        });
      } else {
        alert("6~20자의 영문 소문자, 숫자만 사용 가능합니다.");
      }
    } catch (error) {
      await handleError(error);
      this.setState({
        isIdNotSame: false
      });
    }
  };

  // 회원가입 API 호출 함수.
  handleSignupSubmit = (e: React.FormEvent<HTMLFormElement>) => {
    const {
      isIdOk,
      isIdNotSame,
      isPasswordOk,
      isPasswordSame,
      id,
      password,
      passwordCheck,
      name,
      email,
      birthDate
    } = this.state;
    const { fetchSignup } = this.props;

    e.preventDefault();
    if (isIdOk && isIdNotSame && isPasswordOk && isPasswordSame) {
      fetchSignup({
        id: id,
        password: password,
        passwordCheck: passwordCheck,
        name: name,
        email: email,
        birthDate: birthDate
      });
    } else {
      alert("아이디와 비밀번호를 다시 확인해주세요.");
    }
  };

  render() {
    const { isIdOk, isIdNotSame, isPasswordOk, isPasswordSame } = this.state;
    const { isSignupLoading } = this.props;
    const { handleIdInputChange, handleInputChange, handleIsIdNotSame, handleSignupSubmit } = this;

    return (
      <form className="signup__form" onSubmit={e => handleSignupSubmit(e)}>
        <div className="signup__id-container">
          <input
            type="text"
            name="id"
            className="input signup__input signup__id-input"
            placeholder="아이디 *"
            onChange={e => handleIdInputChange(e)}
            autoComplete="off"
            aria-label="아이디"
            required
          />
          <button
            type="button"
            className="button signup__id-button"
            onClick={() => handleIsIdNotSame()}
          >
            중복확인
          </button>
        </div>
        <span
          className={
            isIdOk
              ? isIdNotSame
                ? "signup__label signup__label--green"
                : "signup__label"
              : "signup__label"
          }
        >
          {isIdOk
            ? isIdNotSame
              ? "사용 가능한 아이디입니다."
              : "아이디가 중복인지 확인하세요."
            : "6~20자의 영문 소문자, 숫자만 사용 가능합니다."}
        </span>
        <input
          type="password"
          name="password"
          className="input signup__input"
          placeholder="비밀번호 *"
          onChange={e => handleInputChange(e)}
          aria-label="비밀번호"
          required
        />
        <input
          type="password"
          name="passwordCheck"
          className="input signup__input"
          placeholder="비밀번호 확인 *"
          onChange={e => handleInputChange(e)}
          aria-label="비밀번호 확인"
          required
        />
        <span
          className={
            isPasswordOk && isPasswordSame ? "signup__label signup__label--green" : "signup__label"
          }
        >
          {isPasswordOk
            ? isPasswordSame
              ? "사용 가능한 비밀번호입니다."
              : "비밀번호가 일치하지 않습니다."
            : "6~20자의 영문, 숫자, 특수문자를 사용하세요."}
        </span>
        <input
          type="text"
          name="name"
          className="input signup__input"
          placeholder="이름 *"
          onChange={e => handleInputChange(e)}
          maxLength={6}
          aria-label="이름"
          required
        />
        <input
          type="text"
          name="email"
          className="input signup__input"
          placeholder="이메일 *"
          onChange={e => handleInputChange(e)}
          aria-label="이메일"
          required
        />
        <div className="signup__birthday-container">
          <span className="signup__birthday-label">생일 *</span>
          <input
            type="date"
            name="birthDate"
            className="input signup__input signup__birthday-input"
            onChange={e => handleInputChange(e)}
            max={moment().format("YYYY-MM-DD")}
            aria-label="생일"
            required
          />
        </div>
        <div className="signup__button-container">
          <Link to="/signin" className="button signup__button">
            로그인
          </Link>
          {isSignupLoading ? (
            <button className="button button--orange signup__button" disabled>
              <img src="/img/Loading.svg" alt="loading" />
            </button>
          ) : (
            <input
              type="submit"
              className="button button--orange signup__button"
              value="회원가입"
            />
          )}
        </div>
      </form>
    );
  }
}

export default withRouter(SignupForm);
