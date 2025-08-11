--CNo.106 溶岩掌ジャイアント・ハンド・レッド
local s, id = GetID()
function s.initial_effect(c)
	--xyz summon
	aux.EnableCheckRankUp(c,nil,nil,63746411)
	Xyz.AddProcedure(c,nil,5,3)
	c:EnableReviveLimit()

	--cannot destroyed
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e0:SetValue(s.indes)
	c:RegisterEffect(e0)

	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(68396121,0))
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(s.negcost)
	e1:SetTarget(s.negtg)
	e1:SetOperation(s.negop)
	e1:SetLabel(RESET_EVENT+RESETS_STANDARD)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_RANKUP_EFFECT)
	e3:SetLabelObject(e1)
	c:RegisterEffect(e3,false,EFFECT_MARKER_DETACH_XMAT)

	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CHANGE_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,0)
	e2:SetCondition(s.damcon)
	e2:SetValue(s.damval)
	c:RegisterEffect(e2)
end
s.xyz_number=106
s.listed_series = {0x48}
s.listed_names={63746411}

function s.indes(e,c)
	return not e:GetHandler():GetBattleTarget():IsSetCard(0x48) 
	  and not e:GetHandler():GetBattleTarget():IsSetCard(0x1048) and not e:GetHandler():GetBattleTarget():IsSetCard(0x2048)
end

function s.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.filter(c)
	return c:IsFaceup() and not c:IsDisabled()
end
function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler())
		and not e:GetHandler():IsStatus(STATUS_CHAINING) end
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,g:GetCount(),0,0)
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e3)
		end
	  tc=g:GetNext()
	  end
end

function s.damcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsOnField() and e:GetHandler():GetPosition()==POS_FACEUP_ATTACK 
end
function s.damval(e,re,val,r,rp,rc)
	if bit.band(r,REASON_EFFECT)~=0 then return 0
	else return val end
end
