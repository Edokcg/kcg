--点火骑士·铠甲(neet)
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--2 Pendulum Monsters, including a "Majespecter" monster
	Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsType,TYPE_PENDULUM),3,3,s.lcheck)   
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(3110)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.immcon)
	e1:SetValue(function(e,re) return e:GetOwnerPlayer()==1-re:GetOwnerPlayer() end)
	c:RegisterEffect(e1)
	-- Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(s.destg)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(s.damtg)
	e3:SetOperation(s.damop)
	c:RegisterEffect(e3)
	aux.GlobalCheck(s,function()
		s[0]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DESTROYED)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
		aux.AddValuesReset(function()
			s[0]=0
		end)
	end)
end
s.listed_series={0xc8}
function s.lcheck(g,lc,sumtype,tp)
	return g:IsExists(Card.IsSetCard,1,nil,0xc8,lc,sumtype,tp)
end
function s.immcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsSetCard,0xc8),tp,LOCATION_MZONE,0,1,e:GetHandler())
end
function s.desfilter(c,e,tp)
	return c:IsCanBeEffectTarget(e) and (c:IsControler(1-tp)
		or (c:IsFaceup() and c:IsSetCard(0xc8)))
end
function s.desrescon(sg,e,tp,mg)
	return sg:FilterCount(Card.IsControler,nil,tp)==1
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local rg=Duel.GetMatchingGroup(s.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,e,tp)
	if chk==0 then return aux.SelectUnselectGroup(rg,e,tp,2,2,s.desrescon,0) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	local g=aux.SelectUnselectGroup(rg,e,tp,2,2,s.desrescon,1,tp,HINTMSG_DESTROY)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetCards(e)
	if #g>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	s[0]=s[0]+eg:FilterCount(Card.IsSetCard,nil,0xc8)
end
function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(s[0]*100)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,s[0]*100)
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end