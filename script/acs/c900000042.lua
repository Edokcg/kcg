--冥界之王
local s, id = GetID()
function s.initial_effect(c)
    aux.god(c,1,id,1)

    local e001 = Effect.CreateEffect(c)
    e001:SetType(EFFECT_TYPE_SINGLE)
    e001:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE + EFFECT_FLAG_CANNOT_DISABLE)
    e001:SetCode(805)
    e001:SetValue(2)
    c:RegisterEffect(e001)

	c:EnableReviveLimit()
	c:SetUniqueOnField(1,1,900000042)
	
	local e00=Effect.CreateEffect(c)
	e00:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE)
	e00:SetType(EFFECT_TYPE_SINGLE)
	e00:SetCode(EFFECT_NOT_EXTRA)
	e00:SetValue(1)
	c:RegisterEffect(e00)

	--特殊召唤限制
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	
	--特殊召唤方式
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(s.spcon)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	
	--表侧表示时攻守变成4000
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_SET_ATTACK)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(4000)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_SET_DEFENSE)
	c:RegisterEffect(e5)
	
	local e18=Effect.CreateEffect(c)
	e18:SetType(EFFECT_TYPE_FIELD)
	e18:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e18:SetCode(EFFECT_CANNOT_LOSE_LP)
	e18:SetRange(LOCATION_MZONE)
	e18:SetTargetRange(1,0)
	e18:SetValue(1)
	c:RegisterEffect(e18)
	local e19=e18:Clone()
	e19:SetCode(EFFECT_CANNOT_LOSE_DECK)
	c:RegisterEffect(e19)
	local e20=e18:Clone()
	e20:SetCode(EFFECT_CANNOT_LOSE_EFFECT)
	c:RegisterEffect(e20)
	
	--特殊召唤冥界暗鸟衍生物
	local e7=Effect.CreateEffect(c)
	e7:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e7:SetDescription(aux.Stringid(900000042,2))
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetCountLimit(1)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCost(s.tokencost)
	e7:SetTarget(s.tokentg)
	e7:SetOperation(s.tokenop)
	c:RegisterEffect(e7)
	
	--可以直接攻击
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e8)
	
	--离场时决斗失败
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e9:SetCode(EVENT_SPSUMMON_SUCCESS)
	e9:SetOperation(s.sucop)
	c:RegisterEffect(e9)
end
s.listed_series={0x21}
s.listed_names={900000043}
--------------------------------------------------------------------------------------------------------
function s.spfilter(c)
	return c:IsSetCard(0x21) and c:IsAbleToRemoveAsCost()
end

function s.spcon(e,c)
	if c==nil then return true end
	if Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)<=0 then return false end
	local g=Duel.GetMatchingGroup(s.spfilter,c:GetControler(),LOCATION_GRAVE,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	return ct>=7
end

function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_GRAVE,0,nil)
	local rg=Group.CreateGroup()
	for i=1,7 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		if tc then
			rg:AddCard(tc)
			g:Remove(Card.IsCode,nil,tc:GetCode())
		end
	end
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
end
--------------------------------------------------
function s.tokencost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetAttackAnnouncedCount()==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end

function s.tokentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,900000043,0,0x4011,2000,0,6,RACE_WINDBEAST,ATTRIBUTE_DARK) end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,ft,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,ft,0,0)
end

function s.tokenop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 or not Duel.IsPlayerCanSpecialSummonMonster(tp,900000043,0,0x4011,2000,0,6,RACE_WINDBEAST,ATTRIBUTE_DARK) then return end
	local g=Group.CreateGroup()
	for i=1,ft do
		local token=Duel.CreateToken(tp,900000043)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		g:AddCard(token)
	end
	Duel.SpecialSummonComplete()
end
-------------------------------------------------------------------------------------------------------------------------------------------
function s.sucop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(tp,999999)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetOperation(s.lose)
	e:GetHandler():RegisterEffect(e1)
end

function s.lose(e,tp,eg,ep,ev,re,r,rp)
	Duel.Win(1-tp,0x4)
end
-------------------------------------------------------------------------------------------------------------------------------------------
function s.damval(e,re,val,r,rp,rc)
	if bit.band(r,REASON_EFFECT)~=0 then return 0 end
	return val
end
-------------------------------------------------------------------------------------------------------------------------------------------
function s.dc(e)
	local tp=e:GetHandler():GetControler()
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 then
		return 1
		else
		return 0
	end
end
