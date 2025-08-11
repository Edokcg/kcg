--絕對黑暗力 (KA)
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)  
	--Atk & Def up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(700)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3) 
	--Equip limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_EQUIP_LIMIT)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetValue(s.eqlimit)
	c:RegisterEffect(e4) 
	--damage
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(5126490,0))
	e5:SetCategory(CATEGORY_DAMAGE+CATEGORY_RECOVER)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_BATTLE_DESTROYING)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCondition(s.damcon)
	e5:SetTarget(s.damtg)
	e5:SetOperation(s.damop)
	c:RegisterEffect(e5)
	--desrep
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(327051,1))
	e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_EQUIP)
	e6:SetCode(EFFECT_DESTROY_REPLACE)
	e6:SetTarget(s.destg)
	e6:SetOperation(s.desop)
	c:RegisterEffect(e6)
end
s.listed_series={0x900}

function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tg=c:GetEquipTarget()
	if chk==0 then return c and not c:IsStatus(STATUS_DESTROY_CONFIRMED)
		and tg and tg:IsReason(REASON_BATTLE+REASON_EFFECT) end
	return Duel.SelectYesNo(tp,aux.Stringid(19333131,0))
end

function s.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT+REASON_REPLACE)
end

function s.damcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetFirst()==e:GetHandler():GetEquipTarget() and eg:GetFirst():IsStatus(STATUS_OPPO_BATTLE)
end

function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	eg:GetFirst():CreateEffectRelation(e)
	local des=eg:GetFirst()
	local dam=des:GetAttack()/2
	if dam<0 then dam=0 end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,dam)
end

function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local des=eg:GetFirst()
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	if des:IsRelateToEffect(e) then
		local dam=des:GetAttack()/2
		if dam<0 then dam=0 end
		if Duel.Damage(p,dam,REASON_EFFECT)>0 then
		Duel.Recover(1-p,dam,REASON_EFFECT) end
	end
end

function s.eqlimit(e,c)
	return c:IsSetCard(0x900)
end

function s.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x900)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and s.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end

function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end

