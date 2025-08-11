--CNo.102 光堕天使ノーブル・デーモン
local s, id = GetID()
function s.initial_effect(c)
	--xyz summon
	aux.EnableCheckRankUp(c,nil,nil,49678559)
	Xyz.AddProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_LIGHT),5,4)
	c:EnableReviveLimit()

	--cannot destroyed
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e0:SetValue(s.indes)
	c:RegisterEffect(e0)

	--destroy replace
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(s.reptg)
	e1:SetOperation(s.repop)
	c:RegisterEffect(e1)

	--disable
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(3606728,1))
	e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1)
	e3:SetCost(s.cost)
	e3:SetTarget(s.target)
	e3:SetOperation(s.operation)
	e3:SetLabel(RESET_EVENT+RESETS_STANDARD)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_RANKUP_EFFECT)
	e5:SetLabelObject(e3)
	c:RegisterEffect(e5,false,EFFECT_MARKER_DETACH_XMAT)
end
s.xyz_number=102
s.listed_series = {0x48}
s.listed_names={49678559}

function s.indes(e,c)
	return not e:GetHandler():GetBattleTarget():IsSetCard(0x48) 
	  and not e:GetHandler():GetBattleTarget():IsSetCard(0x1048) and not e:GetHandler():GetBattleTarget():IsSetCard(0x2048)
end

function s.repcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(255)~=0
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	  local count=e:GetHandler():GetOverlayCount()
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,count,REASON_EFFECT) end
	if Duel.SelectYesNo(tp,aux.Stringid(67173574,0)) then
		if e:GetHandler():RemoveOverlayCard(tp,count,count,REASON_EFFECT)>0 then
			  Duel.SetTargetPlayer(1-tp)
			Duel.SetTargetParam(e:GetHandler():GetAttack())
			Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,1-tp,e:GetHandler():GetAttack())
		return true end
	else return false end
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end

function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.filter(c)
	return c:IsFaceup() and (c:GetAttack()>0 or not c:IsDisabled())
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and s.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,s.filter,tp,0,LOCATION_MZONE,1,1,nil)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() and (tc:GetAttack()>0 or not tc:IsDisabled()) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE_EFFECT)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e3)   
	end
end
