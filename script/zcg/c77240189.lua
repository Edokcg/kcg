--奥西里斯之主宰者-游戏(ZCG)
function c77240189.initial_effect(c)
    --cannot special summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    e1:SetValue(aux.FALSE)
    c:RegisterEffect(e1)

    --summon
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    c:RegisterEffect(e2)

    --summon success
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_SUMMON_SUCCESS)
    e3:SetOperation(c77240189.sumsuc)
    c:RegisterEffect(e3)

    --下降攻击力
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetCondition(c77240189.atkcon)
	e4:SetTarget(c77240189.atktg)
	e4:SetOperation(c77240189.atkop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e6)
end

function c77240189.sumsuc(e,tp,eg,ep,ev,re,r,rp)
    Duel.SetChainLimitTillChainEnd(aux.FALSE)
end

function c77240189.atkfilter(c, tp)
	return c:IsControler(tp) and c:IsPosition(POS_FACEUP)
end

function c77240189.atkcon(e, tp, eg, ep, ev, re, r, rp)
	return eg:IsExists(c77240189.atkfilter, 1, nil, 1 - tp)
end

function c77240189.atktg(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
	if chkc then return eg:IsContains(chkc) and c77240189.atkfilter(chkc,tp) end
	if chk == 0 then
		return e:GetHandler():IsRelateToEffect(e)
	end
	Duel.SetTargetCard(eg:Filter(c77240189.atkfilter,nil,1-tp))
end

function c77240189.atkop(e, tp, eg, ep, ev, re, r, rp)
	local g = Duel.GetChainInfo(0, CHAININFO_TARGET_CARDS)
	local dg = Group.CreateGroup()
	local c = e:GetHandler()
	if g:GetCount() > 0 then
		local tc = g:GetFirst()
		local atk=tc:GetAttack()
		while tc do
			local preatk = tc:GetAttack()
			local predef = tc:GetDefense()
			if tc:GetPosition() == POS_FACEUP_ATTACK and preatk > 0 then
				local e1 = Effect.CreateEffect(c)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetValue(-2000)
				e1:SetReset(RESET_EVENT + 0x1fe0000)
				tc:RegisterEffect(e1)
				if tc:GetAttack() == 0 then
					dg:AddCard(tc)
				end
			end

			if tc:GetPosition() == POS_FACEUP_DEFENSE and predef > 0 then
				local e1 = Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetCode(EFFECT_UPDATE_DEFENSE)
				e1:SetValue(-2000)
				e1:SetReset(RESET_EVENT + 0x1fe0000)
				tc:RegisterEffect(e1)
				if tc:GetDefense() == 0 then
					dg:AddCard(tc)
				end
			end
			tc = g:GetNext()
		end
		Duel.Destroy(dg, REASON_EFFECT)
	end
end